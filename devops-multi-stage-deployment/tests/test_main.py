from fastapi.testclient import TestClient
from src.main import app

client = TestClient(app)

def test_homepage():
    response = client.get("/")
    assert response.status_code == 200
    assert "DevOps Demo App" in response.text

def test_contact_get():
    response = client.get("/contact")
    assert response.status_code == 200
    assert "Contact Form" in response.text

def test_contact_post():
    response = client.post("/contact", data={
        "name": "Nick",
        "email": "nick@example.com",
        "message": "Just testing!"
    })
    assert response.status_code == 200
    assert "Thanks for reaching out" in response.text