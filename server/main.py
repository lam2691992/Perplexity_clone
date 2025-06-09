import asyncio
from fastapi import FastAPI, WebSocket

from pydantic_models.chat_body import ChatBody
from services.llm_service import LLMService
from services.sort_source_service import SortSourceService
from services.search_service import SearchService

app = FastAPI()

search_service = SearchService()
sort_source_service = SortSourceService()
llm_sessions = {}  # lưu phiên theo người dùng

@app.websocket("/ws/chat")
async def websocket_chat_endpoint(websocket: WebSocket):
    await websocket.accept()
    client_id = f"{websocket.client.host}:{websocket.client.port}"

    if client_id not in llm_sessions:
        llm_sessions[client_id] = LLMService()
    llm_service = llm_sessions[client_id]

    try:
        while True:
            data = await websocket.receive_json()
            query = data.get("query")

            search_results = search_service.web_search(query)
            sorted_results = sort_source_service.sort_sources(query, search_results)

            await websocket.send_json({
                'type': 'search_result',
                'data': sorted_results
            })

            for chunk in llm_service.generate_response(query, sorted_results):
                await asyncio.sleep(0.05)
                await websocket.send_json({
                    "type": "content",
                    "data": chunk
                })

    except Exception as e:
        print(f"WebSocket error: {e}")
    finally:
        await websocket.close()
        llm_sessions.pop(client_id, None)


@app.post("/chat")
def chat_endpoint(body: ChatBody):
    # Đơn lượt, không lưu lịch sử
    llm_service = LLMService()
    search_results = search_service.web_search(body.query)
    sorted_results = sort_source_service.sort_sources(body.query, search_results)

    response = llm_service.generate_response(body.query, sorted_results)
    full_response = "".join(response)

    return {"response": full_response}
