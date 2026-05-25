# WhatsApp ZIP to Legal-Grade Chronological Transcript (Kinyarwanda + OPUS)

This guide sets up a reproducible environment to convert an exported WhatsApp ZIP archive (chat text + `.opus` audio notes) into a single timestamped transcript text file with speaker names.

## Scope and output

Input:
- WhatsApp exported ZIP containing `_chat.txt` and media files.
- Audio notes in `.opus` format.
- Primary language: **Kinyarwanda**.

Output:
- `final_transcript.txt` with:
  - chronological ordering,
  - original chat lines,
  - transcribed audio insertions at the corresponding message timestamps,
  - speaker names,
  - processing notes.

## Why this architecture is close to optimal

1. **FFmpeg** normalizes OPUS audio reliably for ASR.
2. **WhisperX (faster-whisper backend)** supports timestamps and optional diarization alignment.
3. **Structured intermediate JSON** preserves provenance and enables QA/auditing.
4. **Deterministic pipeline script** reduces human error.
5. **Hashing + manifest logs** improve legal defensibility.

## Environment setup (Linux)

```bash
bash scripts/setup_whatsapp_pipeline.sh
source .venv-whatsapp/bin/activate
```

## Recommended workflow

1. Put export ZIP in `data/input/`.
2. Unzip into `data/case_001/raw/`.
3. Generate SHA-256 for all original files and store in `data/case_001/evidence_manifest.sha256`.
4. Run processing pipeline (parser + ASR + merge).
5. Review QA report and manually verify low-confidence segments.
6. Freeze outputs (`final_transcript.txt`, JSON, logs, hashes).

## Minimal processing contract

Your pipeline should create these artifacts:

- `normalized_events.jsonl` (all parsed events, ordered)
- `audio_transcripts.jsonl` (per-audio ASR result with confidence/timestamps)
- `merged_timeline.jsonl` (text + audio in one timeline)
- `final_transcript.txt` (human-readable legal packet)
- `run.log` and `versions.txt` (tool versions and parameters)

## Legal-grade controls (must-have)

- Keep original ZIP read-only after intake.
- Generate SHA-256 hashes before and after processing.
- Log timezone assumptions and parsing rules.
- Keep model/version + decoding params for every ASR run.
- Flag uncertain ASR segments for human verification.
- Never overwrite originals; write derived files to a separate folder.

## Kinyarwanda notes

- Use `--language rw` where supported.
- Prefer larger ASR models if hardware allows (accuracy > speed).
- Perform human correction pass by a Kinyarwanda reviewer for court-ready transcript.

## Limits you should disclose in final legal document

- Automated ASR is probabilistic and may contain recognition errors.
- Overlapping speech or noisy audio can reduce accuracy.
- If diarization is model-inferred, speaker attribution for audio can be uncertain.
