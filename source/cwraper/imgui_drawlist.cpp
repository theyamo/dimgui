#include "imgui/imgui.h"

int ImDrawList_GetVertexBufferSize(ImDrawList* list)
{
	return list->VtxBuffer.size();
}

ImDrawVert* ImDrawList_GetVertexPtr(ImDrawList* list, int n)
{
	return &list->VtxBuffer[n];
}

int ImDrawList_GetIndexBufferSize(ImDrawList* list)
{
	return list->IdxBuffer.size();
}

ImDrawIdx* ImDrawList_GetIndexPtr(ImDrawList* list, int n)
{
	return &list->IdxBuffer[n];
}

int ImDrawList_GetCmdSize(ImDrawList* list)
{
	return list->CmdBuffer.size();
}

ImDrawCmd* ImDrawList_GetCmdPtr(ImDrawList* list, int n)
{
	return &list->CmdBuffer[n];
}

void ImDrawData_DeIndexAllBuffers(ImDrawData* drawData)
{
	return drawData->DeIndexAllBuffers();
}

void ImDrawList_Clear(ImDrawList* list)
{
	return list->Clear();
}

void ImDrawList_ClearFreeMemory(ImDrawList* list)
{
	return list->ClearFreeMemory();
}

void ImDrawList_PushClipRect(ImDrawList* list, const struct ImVec2 clip_rect_min, const struct ImVec2 clip_rect_max)
{
	return list->PushClipRect(clip_rect_min, clip_rect_max);
}

void ImDrawList_PushClipRectFullScreen(ImDrawList* list)
{
	return list->PushClipRectFullScreen();
}

void ImDrawList_PopClipRect(ImDrawList* list)
{
	return list->PopClipRect();
}

void ImDrawList_PushTextureID(ImDrawList* list, const ImTextureID texture_id)
{
	return list->PushTextureID(texture_id);
}

void ImDrawList_PopTextureID(ImDrawList* list)
{
	return list->PopTextureID();
}

void ImDrawList_AddLine(ImDrawList* list, const struct ImVec2 a, const struct ImVec2 b, ImU32 col, float thickness)
{
	return list->AddLine(a, b, col, thickness);
}

void ImDrawList_AddRect(ImDrawList* list, const struct ImVec2 a, const struct ImVec2 b, ImU32 col, float rounding, int rounding_corners, float thickness)
{
	return list->AddRect(a, b, col, rounding, rounding_corners, thickness);
}

void ImDrawList_AddRectFilled(ImDrawList* list, const struct ImVec2 a, const struct ImVec2 b, ImU32 col, float rounding, int rounding_corners)
{
	return list->AddRectFilled(a, b, col, rounding, rounding_corners);
}

void ImDrawList_AddRectFilledMultiColor(ImDrawList* list, const struct ImVec2 a, const struct ImVec2 b, ImU32 col_upr_left, ImU32 col_upr_right, ImU32 col_bot_right, ImU32 col_bot_left)
{
	return list->AddRectFilledMultiColor(a, b, col_upr_left, col_upr_right, col_bot_right, col_bot_left);
}

void ImDrawList_AddTriangle(ImDrawList* list, const struct ImVec2 a, const struct ImVec2 b, const struct ImVec2 c, ImU32 col, float thickness)
{
	return list->AddTriangle(a,b,c,col,thickness);
}

void ImDrawList_AddTriangleFilled(ImDrawList* list, const struct ImVec2 a, const struct ImVec2 b, const struct ImVec2 c, ImU32 col)
{
	return list->AddTriangleFilled(a, b, c, col);
}

void ImDrawList_AddCircle(ImDrawList* list, const struct ImVec2 centre, float radius, ImU32 col, int num_segments, float thickness)
{
	return list->AddCircle(centre, radius, col, num_segments, thickness);
}

void ImDrawList_AddCircleFilled(ImDrawList* list, const struct ImVec2 centre, float radius, ImU32 col, int num_segments)
{
	return list->AddCircleFilled(centre, radius, col, num_segments);
}

void ImDrawList_AddText(ImDrawList* list, const struct ImVec2 pos, ImU32 col, const char* text_begin, const char* text_end)
{
	return list->AddText(pos, col, text_begin, text_end);
}

void ImDrawList_AddTextExt(ImDrawList* list, const ImFont* font, float font_size, const struct ImVec2 pos, ImU32 col, const char* text_begin, const char* text_end, float wrap_width, const ImVec4* cpu_fine_clip_rect)
{
	return list->AddText(font, font_size, pos, col, text_begin, text_end, wrap_width, cpu_fine_clip_rect);
}

void ImDrawList_AddImage(ImDrawList* list, ImTextureID user_texture_id, const struct ImVec2 a, const struct ImVec2 b, const struct ImVec2 uv0, const struct ImVec2 uv1, ImU32 col)
{
	return list->AddImage(user_texture_id, a, b, uv0, uv1, col);
}

void ImDrawList_AddPolyline(ImDrawList* list, const ImVec2* points, const int num_points, ImU32 col, bool closed, float thickness, bool anti_aliased)
{
	return list->AddPolyline(points, num_points, col, closed, thickness, anti_aliased);
}

void ImDrawList_AddConvexPolyFilled(ImDrawList* list, const ImVec2* points, const int num_points, ImU32 col, bool anti_aliased)
{
	return list->AddConvexPolyFilled(points, num_points, col, anti_aliased);
}

void ImDrawList_AddBezierCurve(ImDrawList* list, const struct ImVec2 pos0, const struct ImVec2 cp0, const struct ImVec2 cp1, const struct ImVec2 pos1, ImU32 col, float thickness, int num_segments)
{
	return list->AddBezierCurve(pos0, cp0, cp1, pos1, col, thickness, num_segments);
}

void ImDrawList_PathClear(ImDrawList* list)
{
	return list->PathClear();
}

void ImDrawList_PathLineTo(ImDrawList* list, const struct ImVec2 pos)
{
	return list->PathLineTo(pos);
}

void ImDrawList_PathLineToMergeDuplicate(ImDrawList* list, const struct ImVec2 pos)
{
	return list->PathLineToMergeDuplicate(pos);
}

void ImDrawList_PathFill(ImDrawList* list, ImU32 col)
{
	return list->PathFill(col);
}

void ImDrawList_PathStroke(ImDrawList* list, ImU32 col, bool closed, float thickness)
{
	return list->PathStroke(col, closed, thickness);
}

void ImDrawList_PathArcTo(ImDrawList* list, const struct ImVec2 centre, float radius, float a_min, float a_max, int num_segments)
{
	return list->PathArcTo(centre, radius, a_min, a_max, num_segments);
}

void ImDrawList_PathArcToFast(ImDrawList* list, const struct ImVec2 centre, float radius, int a_min_of_12, int a_max_of_12)
{
	return list->PathArcToFast(centre, radius, a_min_of_12, a_max_of_12);
}

void ImDrawList_PathBezierCurveTo(ImDrawList* list, const struct ImVec2 p1, const struct ImVec2 p2, const struct ImVec2 p3, int num_segments)
{
	return list->PathBezierCurveTo(p1, p2, p3, num_segments);
}

void ImDrawList_PathRect(ImDrawList* list, const struct ImVec2 rect_min, const struct ImVec2 rect_max, float rounding, int rounding_corners)
{
	return list->PathRect(rect_min, rect_max, rounding, rounding_corners);
}

void ImDrawList_ChannelsSplit(ImDrawList* list, int channels_count)
{
	return list->ChannelsSplit(channels_count);
}

void ImDrawList_ChannelsMerge(ImDrawList* list)
{
	return list->ChannelsMerge();
}

void ImDrawList_ChannelsSetCurrent(ImDrawList* list, int channel_index)
{
	return list->ChannelsSetCurrent(channel_index);
}

void ImDrawList_AddCallback(ImDrawList* list, ImDrawCallback callback,void* callback_data)
{
	return list->AddCallback(callback, callback_data);
}

void ImDrawList_AddDrawCmd(ImDrawList* list)
{
	return list->AddDrawCmd();
}

void ImDrawList_PrimReserve(ImDrawList* list, int idx_count, int vtx_count)
{
	return list->PrimReserve(idx_count, vtx_count);
}

void ImDrawList_PrimRect(ImDrawList* list, const struct ImVec2 a, const struct ImVec2 b, ImU32 col)
{
	return list->PrimRect(a, b, col);
}

void ImDrawList_PrimRectUV(ImDrawList* list, const struct ImVec2 a, const struct ImVec2 b, const struct ImVec2 uv_a, const struct ImVec2 uv_b, ImU32 col)
{
	return list->PrimRectUV(a, b, uv_a, uv_b, col);
}

void ImDrawList_PrimQuadUV(ImDrawList* list,const struct ImVec2 a, const struct ImVec2 b, const struct ImVec2 c, const struct ImVec2 d, const struct ImVec2 uv_a, const struct ImVec2 uv_b, const struct ImVec2 uv_c, const struct ImVec2 uv_d, ImU32 col)
{
	return list->PrimQuadUV(a,b,c,d,uv_a,uv_b,uv_c,uv_d,col);
}

void ImDrawList_PrimVtx(ImDrawList* list, const struct ImVec2 pos, const struct ImVec2 uv, ImU32 col)
{
	return list->PrimVtx(pos, uv, col);
}

void ImDrawList_PrimWriteVtx(ImDrawList* list, const struct ImVec2 pos, const struct ImVec2 uv, ImU32 col)
{
	return list->PrimWriteVtx(pos, uv, col);
}

void ImDrawList_PrimWriteIdx(ImDrawList* list, ImDrawIdx idx)
{
	return list->PrimWriteIdx(idx);
}

void ImDrawList_UpdateClipRect(ImDrawList* list)
{
	return list->UpdateClipRect();
}

void ImDrawList_UpdateTextureID(ImDrawList* list)
{
	return list->UpdateTextureID();
}
