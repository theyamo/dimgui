#include "imgui/imgui.h"

void ImGuiIO_AddInputCharacter(unsigned short c)
{
    ImGui::GetIO().AddInputCharacter(c);
}

void ImGuiIO_AddInputCharactersUTF8(const char* utf8_chars)
{
    return ImGui::GetIO().AddInputCharactersUTF8(utf8_chars);
}

void ImGuiIO_ClearInputCharacters()
{
    return ImGui::GetIO().ClearInputCharacters();
}


void ImFontConfig_DefaultConstructor(ImFontConfig* config)
{
	*config = ImFontConfig();
}

void ImFontAtlas_GetTexDataAsRGBA32(ImFontAtlas* atlas, unsigned char** out_pixels, int* out_width, int* out_height, int* out_bytes_per_pixel)
{
	atlas->GetTexDataAsRGBA32(out_pixels, out_width, out_height, out_bytes_per_pixel);
}

void ImFontAtlas_GetTexDataAsAlpha8(ImFontAtlas* atlas, unsigned char** out_pixels, int* out_width, int* out_height, int* out_bytes_per_pixel)
{
	atlas->GetTexDataAsAlpha8(out_pixels, out_width, out_height, out_bytes_per_pixel);
}

void ImFontAtlas_SetTexID(ImFontAtlas* atlas, void* tex)
{
	atlas->TexID = tex;
}

ImFont* ImFontAtlas_AddFont(ImFontAtlas* atlas, const ImFontConfig* font_cfg)
{
	return atlas->AddFont(font_cfg);
}

ImFont* ImFontAtlas_AddFontDefault(ImFontAtlas* atlas, const ImFontConfig* font_cfg)
{
	return atlas->AddFontDefault(font_cfg);
}

ImFont* ImFontAtlas_AddFontFromFileTTF(ImFontAtlas* atlas,const char* filename, float size_pixels, const ImFontConfig* font_cfg, const ImWchar* glyph_ranges)
{
	return atlas->AddFontFromFileTTF(filename, size_pixels, font_cfg, glyph_ranges);
}

ImFont* ImFontAtlas_AddFontFromMemoryTTF(ImFontAtlas* atlas, void* ttf_data, int ttf_size, float size_pixels, const ImFontConfig* font_cfg, const ImWchar* glyph_ranges)
{
	return atlas->AddFontFromMemoryTTF(ttf_data, ttf_size, size_pixels, font_cfg, glyph_ranges);
}

ImFont* ImFontAtlas_AddFontFromMemoryCompressedTTF(ImFontAtlas* atlas, const void* compressed_ttf_data, int compressed_ttf_size, float size_pixels, const ImFontConfig* font_cfg, const ImWchar* glyph_ranges)
{
	return atlas->AddFontFromMemoryCompressedTTF(compressed_ttf_data, compressed_ttf_size, size_pixels, font_cfg, glyph_ranges);
}

ImFont* ImFontAtlas_AddFontFromMemoryCompressedBase85TTF(ImFontAtlas* atlas, const char* compressed_ttf_data_base85, float size_pixels, const ImFontConfig* font_cfg, const ImWchar* glyph_ranges)
{
	return atlas->AddFontFromMemoryCompressedBase85TTF(compressed_ttf_data_base85, size_pixels, font_cfg, glyph_ranges);
}

void ImFontAtlas_ClearTexData(ImFontAtlas* atlas)
{
	return atlas->ClearTexData();
}

void ImFontAtlas_Clear(ImFontAtlas* atlas)
{
	return atlas->Clear();
}
