import cv2
import os

video_path = r"d:\vr_city_fps\grabacion-1791739922186.webm"
cap = cv2.VideoCapture(video_path)

output_dir = r"C:\Users\ildem\.gemini\antigravity-ide\brain\7b213197-7ff3-4d01-90b1-cca8c393f355\latest_video_inspect"
os.makedirs(output_dir, exist_ok=True)

# Save frames 0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300
target_frames = [0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300]
current = 0

while cap.isOpened() and target_frames:
    ret, frame = cap.read()
    if not ret:
        break
    if current in target_frames:
        out_name = os.path.join(output_dir, f"step_{current:04d}.png")
        cv2.imwrite(out_name, frame)
        target_frames.remove(current)
    current += 1

cap.release()
print("Saved inspect frames.")
