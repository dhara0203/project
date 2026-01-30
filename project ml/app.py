import streamlit as st
import joblib
import os
import re
import string

# ====== PAGE CONFIG ======
st.set_page_config(page_title="Spam Detector", page_icon="📧")
st.title("📧 Spam Detector NLP App")

# ====== MODEL PATH ======
MODEL_PATH = r"C:\Users\dhara\Downloads\spam_nlp_model.pkl"

# ====== LOAD MODEL ======
@st.cache_resource
def load_model(path):
    if os.path.exists(path):
        return joblib.load(path)
    else:
        st.error(f"❌ Model not found at: {path}")
        return None

model = load_model(MODEL_PATH)

# ====== CLEAN TEXT FUNCTION ======
def clean_text(text):
    text = text.lower()
    text = re.sub(r'\d+', '', text)
    text = re.sub(r'\[.*?\]', '', text)
    text = re.sub(r'https?://\S+|www\.\S+', '', text)
    text = re.sub(r'<.*?>+', '', text)
    text = re.sub(r'[%s]' % re.escape(string.punctuation), '', text)
    text = re.sub(r'\n', '', text)
    return text

# ====== USER INPUT ======
user_input = st.text_area("Enter the message to check:")

if st.button("Check Spam"):
    if not user_input.strip():
        st.warning("Please enter a message!")
    elif model is None:
        st.error("Model is not loaded!")
    else:
        cleaned_input = clean_text(user_input)
        prediction = model.predict([cleaned_input])[0]
        # Show green for HAM and red for SPAM
        if prediction == 0:
            st.success("HAM ✅")
        else:
            st.error("SPAM 🚫")

