# api/v1/endpoints/chat.py
from fastapi import APIRouter, WebSocket, Depends, HTTPException, WebSocketDisconnect
from app.services.websocket import manager
from app.dependencies import get_current_user
from app.core.deps import get_current_user
from app.services.chat import ChatManager


chat_router = APIRouter()
chat_manager = ChatManager()


@chat_router.websocket("/ws/{user_id}")
async def websocket_endpoint(
    websocket: WebSocket,
    user_id: int,
    current_user: User = Depends(get_current_user)
):
    await manager.connect(websocket, user_id)
    try:
        while True:
            data = await websocket.receive_text()
            await manager.broadcast(f"Message: {data}", user_id)
    except Exception as e:
        await manager.disconnect(websocket, user_id)




@chat_router.websocket("/ws/{chat_room_id}")
async def chat_websocket(
    websocket: WebSocket,
    chat_room_id: str,
    current_user = Depends(get_current_user)
):
    await chat_manager.connect(websocket, chat_room_id, current_user.id)
    try:
        while True:
            message = await websocket.receive_text()
            await chat_manager.broadcast_message(chat_room_id, message, current_user.id)
    except WebSocketDisconnect:
        await chat_manager.disconnect(websocket, chat_room_id, current_user.id)