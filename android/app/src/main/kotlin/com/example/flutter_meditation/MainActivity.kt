package com.example.flutter_meditation

import android.content.Context
import android.media.AudioAttributes
import android.media.AudioFormat
import android.media.AudioTrack
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import android.util.Log
import androidx.annotation.RequiresApi
import kotlin.math.sin
import kotlin.math.PI

class MainActivity: FlutterActivity() {
    private val CHANNEL = "htw.berlin.de/public_health/binaural_beats"
    private lateinit var toneGenerator: ToneGenerator
    private val LOG_TAG = "FLUTTER_APP"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            try {
                when (call.method) {
                    "playBinauralBeat" -> {
                        val frequencyLeft = call.argument<Double>("frequencyLeft") ?: 0.0
                        val frequencyRight = call.argument<Double>("frequencyRight") ?: 0.0
                        val duration = call.argument<Double>("duration") ?: 0.0
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                            if (::toneGenerator.isInitialized) {
                                toneGenerator.stopPlayingTone()
                            }
                            playBinauralBeat(frequencyLeft, frequencyRight, duration, result)
                        }
                    }
                    "stopBinauralBeat" -> stopBinauralBeat(result)
                    else -> result.notImplemented()
                }
            } catch (e: Exception) {
                result.error("UNAVAILABLE", "Error generating/stopping sound.", null)
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun playBinauralBeat(frequencyLeft: Double, frequencyRight: Double, duration: Double, result: MethodChannel.Result) {
        toneGenerator = ToneGenerator()
        toneGenerator.generateTone(frequencyLeft, frequencyRight, duration, applicationContext)
        result.success(true)
    }

    private fun stopBinauralBeat(result: MethodChannel.Result) {
        toneGenerator.stopPlayingTone()
        result.success(true)
    }
}

class ToneGenerator {
    private val sampleRate = 44100
    private var audioTrack: AudioTrack? = null
    private var isPlaying = false
    private lateinit var audioThread: Thread

    @RequiresApi(Build.VERSION_CODES.M)
    fun generateTone(frequencyLeft: Double, frequencyRight: Double, duration: Double, context: Context) {
        val bufferSize = AudioTrack.getMinBufferSize(sampleRate, AudioFormat.CHANNEL_OUT_STEREO, AudioFormat.ENCODING_PCM_16BIT) * 3
        audioTrack = AudioTrack.Builder()
            .setAudioAttributes(AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_MEDIA)
                .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                .build())
            .setAudioFormat(AudioFormat.Builder()
                .setSampleRate(sampleRate)
                .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
                .setChannelMask(AudioFormat.CHANNEL_OUT_STEREO)
                .build())
            .setBufferSizeInBytes(bufferSize)
            .build()

        audioTrack?.play()
        isPlaying = true

        var phaseLeft = 0.0
        var phaseRight = 0.0
        val twoPi = 2.0 * Math.PI

        audioThread = Thread {
            val endTime = System.currentTimeMillis() + (duration * 1000).toLong()
            while (isPlaying && System.currentTimeMillis() < endTime) {
                val chunkSize = bufferSize / 6
                val pcmData = ShortArray(chunkSize * 2) // Stereo: two channels

                for (i in 0 until chunkSize) {
                    val sampleLeft = sin(phaseLeft).toFloat()
                    val sampleRight = sin(phaseRight).toFloat()

                    pcmData[i * 2] = (sampleLeft * Short.MAX_VALUE).toInt().toShort()
                    pcmData[i * 2 + 1] = (sampleRight * Short.MAX_VALUE).toInt().toShort()

                    phaseLeft += twoPi * frequencyLeft / sampleRate
                    phaseRight += twoPi * frequencyRight / sampleRate

                    // Keep the phase within the 0 to twoPi range
                    phaseLeft %= twoPi
                    phaseRight %= twoPi
                }

                audioTrack?.write(pcmData, 0, pcmData.size)
            }
            stopPlayingTone()
        }
        audioThread.start()
    }

    fun stopPlayingTone() {
        synchronized(this) {
            if (!isPlaying) return

            // Flag to stop the audio thread
            isPlaying = false

            // Wait for the audio thread to finish its current operation
            if (::audioThread.isInitialized && audioThread.isAlive) {
                try {
                    audioThread.join(1000) // Wait for 1 second for the thread to join
                } catch (e: InterruptedException) {
                    Thread.currentThread().interrupt() // Restore interrupt status
                }
            }

            // Stop and release AudioTrack
            audioTrack?.apply {
                stop()
                release()
            }
            audioTrack = null
        }
    }

}
