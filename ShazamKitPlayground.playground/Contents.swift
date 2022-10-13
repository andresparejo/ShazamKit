import AVFoundation
import ShazamKit
import PlaygroundSupport

func convert(audioFile: AVAudioFile, outputFormat: AVAudioFormat, pcmBlock: (AVAudioPCMBuffer) -> Void) {
    let frameCount = AVAudioFrameCount(
        (1024 * 64) / (audioFile.processingFormat.streamDescription.pointee.mBytesPerFrame)
    )
    let outputFrameCapacity = AVAudioFrameCount(
         round(Double(frameCount) * (outputFormat.sampleRate / audioFile.processingFormat.sampleRate))
    )

    guard let inputBuffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: frameCount),
          let outputBuffer = AVAudioPCMBuffer(pcmFormat: outputFormat, frameCapacity: outputFrameCapacity) else {
        return
    }

    let inputBlock : AVAudioConverterInputBlock = { inNumPackets, outStatus in
        do {
            try audioFile.read(into: inputBuffer)
            outStatus.pointee = .haveData
            return inputBuffer
        } catch {
            if audioFile.framePosition >= audioFile.length {
                outStatus.pointee = .endOfStream
                return nil
            } else {
                outStatus.pointee = .noDataNow
                return nil
            }
        }
    }

    guard let converter = AVAudioConverter(from: audioFile.processingFormat, to: outputFormat) else {
        return
    }

    while true {

        let status = converter.convert(to: outputBuffer, error: nil, withInputFrom: inputBlock)

        if status == .error || status == .endOfStream {
            return
        }

        pcmBlock(outputBuffer)

        if status == .inputRanDry {
            return
        }

        inputBuffer.frameLength = 0
        outputBuffer.frameLength = 0
    }
}

func makeShazamSignature(inputAudioURL: URL?) {
    guard let inputAudioURL = inputAudioURL else {
        return
    }

    let signatureGenerator = SHSignatureGenerator()
    
    do {
        let audioFile = try AVAudioFile(forReading: inputAudioURL)
        let pcmBlock: ((AVAudioPCMBuffer) -> Void) = { buffer in
            do {
                try signatureGenerator.append(buffer, at: nil)
                guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                                print("No documents directory found.")
                                return
                            }
                let fileURL = documentsDirectory.appendingPathComponent(inputAudioURL.lastPathComponent).appendingPathExtension("shazamsignature")

                            try signatureGenerator.signature().dataRepresentation.write(to: fileURL, options: .atomic)
                            print("Signature Successfully Generated: \(fileURL)")
            } catch {
                // Handle signature generator error
            }
        }

        convert(audioFile: audioFile, outputFormat: AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)!, pcmBlock: pcmBlock)

    } catch let error {
        print(error)
    }
}

//MARK: - NOTE
/// please add your trim videos on the resource folder and uncomment / declare them below
makeShazamSignature(inputAudioURL: Bundle.main.url(forResource: "trimtrim", withExtension: "mp4"))
                    

