import google.generativeai as genai
from config import Settings

settings = Settings()

class LLMService:
    def __init__(self):
        genai.configure(api_key=settings.GEMINI_API_KEY)
        self.model = genai.GenerativeModel("gemini-2.5-flash-preview-05-20")
        
    def generate_response(self, query: str, search_results: list[dict]):
        context_text = "\n\n".join([
            f"Source {i+1} ({result['url']}):\n{result['content']}"
            for i, result in enumerate(search_results)
            if result.get("content")
        ])
        
        full_prompt = f"""
Context from web search:
{context_text}

Query: {query}

Please provide a comprehensive, detailed, well-cited and accurate response using only the context above.
Think step-by-step. Answer the question clearly and thoroughly.
Avoid using outside knowledge unless strictly necessary.
"""

        response = self.model.generate_content(full_prompt, stream=True)
        
        for chunk in response:
            yield chunk.text
