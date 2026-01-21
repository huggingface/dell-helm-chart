import os
import base64
from io import BytesIO
from PIL import Image
import gradio as gr
from openai import OpenAI

# Get TGI backend URL from environment variable
TGI_URL = os.environ.get("TGI_URL", "http://localhost:80")

# Initialize OpenAI client pointing to TGI
client = OpenAI(
    base_url=f"{TGI_URL}/v1",
    api_key="EMPTY"  # TGI doesn't require authentication by default
)

MODEL_ID = "meta-llama/Meta-Llama-3.2-11B-Vision-Instruct"


def encode_image(image):
    """Encode PIL Image to base64 string."""
    buffered = BytesIO()
    image.save(buffered, format="PNG")
    img_str = base64.b64encode(buffered.getvalue()).decode()
    return f"data:image/png;base64,{img_str}"


def bot_streaming(message, history, max_new_tokens=250):
    """
    Handle multimodal chat with streaming responses.

    Args:
        message: Dict with 'text' and 'files' keys
        history: List of conversation history
        max_new_tokens: Maximum number of tokens to generate
    """
    txt = message["text"]
    messages = []

    # Process conversation history
    for i, msg in enumerate(history):
        if isinstance(msg[0], tuple):
            # This is an image message
            image = Image.open(msg[0][0]).convert("RGB")
            image_url = encode_image(image)

            # User message with image
            if i + 1 < len(history) and isinstance(history[i + 1][0], str):
                messages.append({
                    "role": "user",
                    "content": [
                        {"type": "text", "text": history[i + 1][0]},
                        {"type": "image_url", "image_url": {"url": image_url}}
                    ]
                })
                # Assistant response
                if history[i + 1][1]:
                    messages.append({
                        "role": "assistant",
                        "content": history[i + 1][1]
                    })
        elif isinstance(msg[0], str):
            # Skip if already processed as part of image message
            if i > 0 and isinstance(history[i - 1][0], tuple):
                continue
            # Regular text message
            messages.append({
                "role": "user",
                "content": msg[0]
            })
            if msg[1]:
                messages.append({
                    "role": "assistant",
                    "content": msg[1]
                })

    # Add current message
    if len(message.get("files", [])) >= 1:
        # Message with image
        if isinstance(message["files"][0], str):
            image = Image.open(message["files"][0]).convert("RGB")
        else:
            image = Image.open(message["files"][0]["path"]).convert("RGB")

        image_url = encode_image(image)
        messages.append({
            "role": "user",
            "content": [
                {"type": "text", "text": txt},
                {"type": "image_url", "image_url": {"url": image_url}}
            ]
        })
    else:
        # Text-only message
        messages.append({
            "role": "user",
            "content": txt
        })

    # Stream response from TGI
    try:
        stream = client.chat.completions.create(
            model=MODEL_ID,
            messages=messages,
            max_tokens=max_new_tokens,
            stream=True
        )

        buffer = ""
        for chunk in stream:
            if chunk.choices[0].delta.content:
                buffer += chunk.choices[0].delta.content
                yield buffer

    except Exception as e:
        yield f"Error: {str(e)}\n\nPlease check that the TGI backend is running at {TGI_URL}"


# Create Gradio interface
demo = gr.ChatInterface(
    fn=bot_streaming,
    title="Multimodal Llama 3.2 Vision",
    examples=[
        [{"text": "Which era does this piece belong to? Give details about the era.", "files": []}, 200],
        [{"text": "What do you see in this image?", "files": []}, 250],
        [{"text": "Describe this image in detail.", "files": []}, 250],
    ],
    textbox=gr.MultimodalTextbox(),
    additional_inputs=[
        gr.Slider(
            minimum=10,
            maximum=500,
            value=250,
            step=10,
            label="Maximum number of new tokens to generate",
        )
    ],
    cache_examples=False,
    description=f"""
    Try Multimodal Llama 3.2 Vision by Meta with Text Generation Inference (TGI).

    Upload an image and start chatting about it, or simply ask questions.

    **Backend URL:** {TGI_URL}

    To learn more about Llama Vision, visit [the blog post](https://huggingface.co/blog/llama32).
    """,
    stop_btn="Stop Generation",
    fill_height=True,
    multimodal=True
)

if __name__ == "__main__":
    demo.launch(
        server_name="0.0.0.0",
        server_port=7860,
        debug=True
    )
