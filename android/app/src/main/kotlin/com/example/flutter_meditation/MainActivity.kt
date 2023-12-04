package com.example.flutter_meditation

import android.content.Context
import android.media.AudioAttributes
import android.media.AudioFormat
import android.media.AudioManager
import android.media.AudioTrack
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import android.util.Log

class MainActivity: FlutterActivity() {
    private val CHANNEL = "htw.berlin.de/public_health/binaural_beats"
    private val toneGenerator = ToneGenerator()
    private val LOG_TAG = "FLUTTER_APP"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // create the message channel object to get the caller data from flutter
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            Log.d(LOG_TAG, "Method channel call registered")

            try {
                val frequencyLeft = call.argument<Double>("frequencyLeft")
                val frequencyRight = call.argument<Double>("frequencyRight")

                // here we check which method is called from flutter
                when (call.method) {
                    "playBinauralBeat" -> {
                        Log.d(LOG_TAG, "playBinauralBeat called")
                        playBinauralBeat(frequencyLeft, frequencyRight, result);
                    }
                    "stopBinauralBeat" -> {
                        Log.d(LOG_TAG, "stopBinauralBeat called")
                        stopBinauralBeat(result);
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            } catch (e: Exception) {
                result.error("UNAVAILABLE", "Error generating / stopping sound (AudioTrack).", e.toString())
            }
        }
    }

    private fun playBinauralBeat(frequencyLeft: Double?, frequencyRight: Double?, result: MethodChannel.Result){
        if (frequencyLeft != null && frequencyRight != null) {
            toneGenerator.generateTone(frequencyLeft, frequencyRight, context)
            result.success(true)
        } else {
            result.error("INVALID_ARGUMENTS", "Invalid arguments for playBinauralBeat", null)
        }
    }

    private fun stopBinauralBeat(result: MethodChannel.Result){
        toneGenerator.stopPlayingTone()
        result.success(true)
    }

}

class ToneGenerator(){

    private lateinit var audioTrack: AudioTrack
    private var bufferSize = 0
    private val sampleRate = 44100 // Standard-Abtastfrequenz
    private val duration = 1.0 // Beispiel-Dauer des Tons in Sekunden
    private var isPlaying = false

    fun stopPlayingTone(){
        Log.d("FLUTTER_APP", "Stop coroutine playing sound")
        isPlaying = false
    }

    fun generateTone(frequencyLeft: Double, frequencyRight: Double, context: Context) {
        bufferSize = (sampleRate * duration).toInt()
        val builder = AudioTrack.Builder().setAudioAttributes(AudioAttributes.Builder().setUsage(AudioAttributes.USAGE_MEDIA)
                .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC).build())
                .setAudioFormat(AudioFormat.Builder().setSampleRate(sampleRate)
                .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
                .setChannelMask(AudioFormat.CHANNEL_OUT_STEREO).build())
                .setBufferSizeInBytes(bufferSize)
        audioTrack = builder.build()
        audioTrack.play()

        val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        startToneGeneration(frequencyLeft, frequencyRight, audioManager)
    }

    // AudioManager as a parameter is required to make the user able to control the volume while playing the tone
    private fun startToneGeneration(frequencyLeft: Double, frequencyRight: Double, audioManager: AudioManager){

        isPlaying = true
        val maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC)

        // asynchrone Ausführung in CoRoutine
        Log.d("FLUTTER_APP", "Start coroutine playing sound")
        GlobalScope.launch {
            while (isPlaying) {
                val currentVolume = audioManager.getStreamVolume(AudioManager.STREAM_MUSIC)
                val amplitude = currentVolume.toFloat() / maxVolume.toFloat()

                val pcmData = generateStereoSinWave(bufferSize, frequencyLeft, frequencyRight, amplitude)
                audioTrack.write(pcmData, 0, bufferSize)
            }
        }
    }


    private fun generateStereoSinWave(numSamples: Int, frequencyLeft: Double, frequencyRight: Double, amplitude: Float): ShortArray {
        val pcmData = ShortArray(numSamples * 2)

        for (i in 0 until numSamples * 2 step 2) {
            // amplitude is the volume
            val sampleLeft = amplitude * Math.sin(2.0 * Math.PI * frequencyLeft * i / (sampleRate * 2.0))
            val sampleRight = amplitude * Math.sin(2.0 * Math.PI * frequencyRight * i / (sampleRate * 2.0))

            // In pcmData ist wechselt das Ohr bei jeder Arrayposition,
            // also Muster: samples[0] linkes Ohr, samples[1] rechtes Ohr, samples[2] linkes Ohr ...
            pcmData[i] = (sampleLeft * Short.MAX_VALUE).toInt().toShort() // Linkes Ohr
            pcmData[i + 1] = (sampleRight * Short.MAX_VALUE).toInt().toShort() // Rechtes Ohr
        }

        return pcmData
    }

}
