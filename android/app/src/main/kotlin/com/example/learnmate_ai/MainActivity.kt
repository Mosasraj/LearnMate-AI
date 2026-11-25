
package com.example.learnmate_ai

import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.pytorch.executorch.extension.llm.LlmCallback
import org.pytorch.executorch.extension.llm.LlmGenerationConfig
import org.pytorch.executorch.extension.llm.LlmModule
import java.io.File
import java.util.concurrent.Executors
import java.util.concurrent.atomic.AtomicBoolean

class MainActivity : FlutterActivity() {

    private val CHANNEL = "learnmate/ai"

    private val executor = Executors.newSingleThreadExecutor()
    private val mainHandler = Handler(Looper.getMainLooper())

    @Volatile
    private var llmModule: LlmModule? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                // LOAD OFFLINE MODEL
                "loadModel" -> {
                    val replied = AtomicBoolean(false)

                    executor.execute {
                        try {
                            val modelDirectory =
                                getExternalFilesDir("models")
                                    ?: throw Exception("Model directory unavailable")

                            val modelFile = File(modelDirectory, "model.pte")
                            val tokenizerFile = File(modelDirectory, "tokenizer.model")

                            if (!modelFile.exists()) {
                                throw Exception(
                                    "Model not found: ${modelFile.absolutePath}"
                                )
                            }

                            if (!tokenizerFile.exists()) {
                                throw Exception(
                                    "Tokenizer not found: ${tokenizerFile.absolutePath}"
                                )
                            }

                            val module = LlmModule(
                                modelFile.absolutePath,
                                tokenizerFile.absolutePath,
                                0.7f
                            )

                            // load() returns Unit. Do not compare it with zero.
                            module.load()

                            llmModule = module

                            if (replied.compareAndSet(false, true)) {
                                mainHandler.post {
                                    result.success(
                                        "Llama model loaded successfully"
                                    )
                                }
                            }

                        } catch (e: Exception) {
                            if (replied.compareAndSet(false, true)) {
                                mainHandler.post {
                                    result.error(
                                        "MODEL_LOAD_ERROR",
                                        e.message,
                                        null
                                    )
                                }
                            }
                        }
                    }
                }

                // GENERATE AI RESPONSE
                "generate" -> {
                    val prompt = call.argument<String>("prompt")

                    if (prompt.isNullOrBlank()) {
                        result.error(
                            "INVALID_PROMPT",
                            "Prompt is empty",
                            null
                        )
                        return@setMethodCallHandler
                    }

                    executor.execute {
                        val replied = AtomicBoolean(false)

                        fun sendError(message: String) {
                            if (replied.compareAndSet(false, true)) {
                                mainHandler.post {
                                    result.error(
                                        "GENERATION_ERROR",
                                        message,
                                        null
                                    )
                                }
                            }
                        }

                        try {
                            val module = llmModule
                                ?: throw Exception("Load the model first")

                            val response = StringBuilder()

                            val generationConfig =
                                LlmGenerationConfig.create()
                                    .seqLen(2048)
                                    .maxNewTokens(256)
                                    .temperature(0.7f)
                                    .echo(false)
                                    .build()

                            val callback = object : LlmCallback {

                                override fun onResult(token: String) {
                                    response.append(token)
                                }

                                override fun onStats(statsJson: String) {
                                    if (replied.compareAndSet(false, true)) {
                                        mainHandler.post {
                                            result.success(response.toString())
                                        }
                                    }
                                }

                                override fun onError(
                                    errorCode: Int,
                                    message: String
                                ) {
                                    sendError(
                                        "Error $errorCode: $message"
                                    )
                                }
                            }

                            module.generate(
                                prompt,
                                generationConfig,
                                callback
                            )

                        } catch (e: Exception) {
                            sendError(
                                e.message ?: "Unknown generation error"
                            )
                        }
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        executor.shutdown()
        super.onDestroy()
    }
}
