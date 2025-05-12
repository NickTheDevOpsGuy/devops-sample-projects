from fastapi import FastAPI, Request, Form
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from pathlib import Path

app = FastAPI()
BASE_DIR = Path(__file__).resolve().parent
app.mount("/static", StaticFiles(directory=BASE_DIR / "static"), name="static")
templates = Jinja2Templates(directory=BASE_DIR / "templates")

visitor_count = 0

@app.get("/")
async def homepage(request: Request):
    global visitor_count
    visitor_count += 1
    return templates.TemplateResponse("index.html", {"request": request, "visitor_count": visitor_count})

@app.get("/contact")
async def contact_form(request: Request):
    return templates.TemplateResponse("contact.html", {"request": request, "message": None})

@app.post("/contact")
async def handle_contact(
    request: Request,
    name: str = Form(...),
    email: str = Form(...),
    message: str = Form(...)
):
    print(f"New contact submission from {name} ({email}): {message}")
    return templates.TemplateResponse("contact.html", {
        "request": request,
        "message": f"Thanks for reaching out, {name}! We'll be in touch."
    })