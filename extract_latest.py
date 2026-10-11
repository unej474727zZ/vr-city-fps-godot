import cv2
import os

video_path = r"d:\vr_city_fps\grabacion-1791739922186.webm"
output_dir = r"C:\Users\ildem\.gemini\antigravity-ide\brain\7b213197-7ff3-4d01-90b1-cca8c393f355\latest_video_frames"
os.makedirs(output_dir, exist_ok=True)

cap = cv2.VideoCapture(video_path)
frame_count = 0
saved = 0

while cap.isOpened():
    ret, frame = cap.read()
    if not ret:
        break
    if frame_count % 30 == 0:
        out_name = os.path.join(output_dir, f"frame_{saved:03d}_f{frame_count}.png")
        cv2.imwrite(out_name, frame)
        saved += 1
    frame_count += 1

cap.release()
print(f"Total frames: {frame_count}. Saved {saved} samples.")
