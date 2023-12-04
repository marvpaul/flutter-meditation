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
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch


class MainActivity: FlutterActivity() {
    private val CHANNEL = "htw.berlin.de/public_health/binaural_beats"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // create the message channel object to play binaural beatss
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->

            try {
                val frequencyLeft = call.argument<Double>("frequencyLeft")
                val frequencyRight = call.argument<Double>("frequencyRight")

                // here we check which method is called
                if (call.method == "playBinauralBeat" && frequencyLeft != null && frequencyRight != null) {

                    val toneGenerator = ToneGenerator()
                    toneGenerator.generateTone(frequencyLeft, frequencyRight, context)
                    result.success(true)

                } else {
                    result.notImplemented()
                }
            } catch (e: Exception) {
                result.error("UNAVAILABLE", "Error generating sound (AudioTrack).", null)
            }
        }

    }

    override fun onResume() {
        super.onResume()
        //setVolumeControlStream(AudioManager.STREAM_MUSIC)

    }

}


class ToneGenerator(){

    private lateinit var audioTrack: AudioTrack
    private var bufferSize = 0
    private val sampleRate = 44100 // Beispiel-Abtastfrequenz
    //private var amplitude = 0.5 // Beispiel-Amplitude (0.0 bis 1.0)
    private val duration = 3.0 // Beispiel-Dauer des Tons in Sekunden
    //private lateinit var audioManager: AudioManager
    private var isPlaying = false


    fun generateTone(frequencyLeft: Double, frequencyRight: Double, context: Context) {
        // Berechne die Puffergröße
        bufferSize = AudioTrack.getMinBufferSize(sampleRate, AudioFormat.CHANNEL_OUT_MONO, AudioFormat.ENCODING_PCM_16BIT)

        val builder = AudioTrack.Builder().setAudioAttributes(AudioAttributes.Builder().setUsage(AudioAttributes.USAGE_MEDIA)
                .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC).build())
        builder.setAudioFormat(AudioFormat.Builder().setSampleRate(sampleRate).setEncoding(AudioFormat.ENCODING_PCM_16BIT)
                .setChannelMask(AudioFormat.CHANNEL_OUT_STEREO).build())
        builder.setBufferSizeInBytes(bufferSize)

        audioTrack = builder.build()

        audioTrack.play()

        isPlaying = true
        val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        val maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC)

        val bufferSize = (sampleRate * duration).toInt()

        // asychrone Ausführung in CoRoutine
        GlobalScope.launch {
            while (isPlaying) {
                val currentVolume = audioManager.getStreamVolume(AudioManager.STREAM_MUSIC)
                val amplitude = currentVolume.toFloat() / maxVolume.toFloat()

                val pcmData = generateStereoSinWave(bufferSize, frequencyLeft, frequencyRight, amplitude)
                audioTrack.write(pcmData, 0, bufferSize)

                //delay(500)
            }
        }

        /*var audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        val currentVolume = audioManager.getStreamVolume(AudioManager.STREAM_MUSIC)
        val maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
        val amplitude = currentVolume.toFloat() / maxVolume.toFloat()
        audioTrack.setVolume(amplitude.toFloat())
        audioTrack.play()
        audioTrack.setVolume(amplitude.toFloat())

        // Erzeuge und spiele den Ton ab
        generateAndPlayTone(frequencyLeft, frequencyRight, context)*/
    }

    private fun generateAndPlayTone(frequencyLeft: Double, frequencyRight: Double, context: Context) {
        // Berechne die Anzahl der Abtastpunkte für die gegebene Dauer
        val numSamples = (sampleRate * duration).toInt()

        // Erzeuge PCM-Daten für den Ton
        //val pcmData = generateStereoSinWave(numSamples, frequencyLeft, frequencyRight, context)

        // Spiele die PCM-Daten ab
        //audioTrack.write(pcmData, 0, numSamples)
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
