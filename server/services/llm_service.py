import google.generativeai as genai
from config import Settings

settings = Settings()

class LLMService:
    def __init__(self):
        genai.configure(api_key=settings.GEMINI_API_KEY)
        self.model = genai.GenerativeModel("gemini-1.5-flash")
        self.chat_session = self.model.start_chat(history=[])

    def generate_response(self, query: str, search_results: list[dict]):
        context_text = "\n\n".join([
            f"Source {i+1} ({result['url']}):\n{result['content']}"
            for i, result in enumerate(search_results)
            if result.get("content")
        ])

        prompt = f"""
Bạn là một trợ lý AI có khả năng trả lời câu hỏi chính xác, mạch lạc và theo ngôn ngữ được sử dụng trong câu hỏi của người dùng.

Dưới đây là ngữ cảnh tìm kiếm từ web:
{context_text}

Câu hỏi của người dùng:
{query}

Yêu cầu:
- Trả lời bằng **cùng ngôn ngữ với câu hỏi** (ví dụ: nếu câu hỏi bằng tiếng Anh, trả lời bằng tiếng Anh; nếu bằng tiếng Việt, trả lời bằng tiếng Việt).
- Dựa hoàn toàn vào thông tin trong ngữ cảnh trên, chỉ bổ sung kiến thức nền nếu thực sự cần thiết.
- Nếu thông tin không có trong ngữ cảnh, hãy nói rõ "Thông tin không có sẵn trong ngữ cảnh" thay vì suy đoán.
- Trình bày câu trả lời rõ ràng, có cấu trúc (liệt kê, phân đoạn, hoặc theo bước nếu phù hợp).
- Luôn suy luận từng bước trước khi đưa ra kết luận.
"""

        response = self.chat_session.send_message(prompt, stream=True)
        for chunk in response:
            yield chunk.text
