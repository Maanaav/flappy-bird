# MORSE_CODE_DICT = {
#     "A": ".-", "B": "-...", "C": "-.-.", "D": "-..", "E": ".", "F": "..-.", "G": "--.", "H": "....", "I": "..",
#     "J": ".---", "K": "-.-", "L": ".-..", "M": "--", "N": "-.", "O": "---", "P": ".--.", "Q": "--.-", "R": ".-.",
#     "S": "...", "T": "-", "U": "..-", "V": "...-", "W": ".--", "X": "-..-", "Y": "-.--", "Z": "--..", "1": ".----",
#     "2": "..---", "3": "...--", "4": "....-", "5": ".....", "6": "-....", "7": "--...", "8": "---..", "9": "----.",
#     "0": "-----", ", ": "--..--", ".": ".-.-.-", "?": "..--..", "/": "-..-.", "-": "-....-", "(": "-.--.",
#     ")": "-.--.-",
# }
#
# mssg = "...."
#
# for keys, value in MORSE_CODE_DICT.items():
#     if value == mssg:
#         print(keys)
import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse
from loguru import logger

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
async def default():
    return "my api endpoint"


@app.get("/tap/{file_name}/{my_tap}")
async def tap(file_name: str, my_tap: str):
    if my_tap == "dot":
        my_tap = "."
    if my_tap == "slash":
        my_tap = "/"
    if my_tap == "space":
        my_tap = " "

    try:
        with open(f"{file_name}.txt", "a") as file:
            file.write(my_tap)
    except:
        logger.error("couldn't register tap!")

    return "got it!"


@app.get("/tap/{file_name}")
async def file_download(file_name: str):
    try:
        if os.path.exists(f"{file_name}"):
            return FileResponse(f"{file_name}")
        else:
            return "File not found"
    except:
        return "File not found"
