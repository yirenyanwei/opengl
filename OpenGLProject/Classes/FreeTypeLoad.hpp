//
//  FreeTypeLoad.hpp
//  OpenGLProject
//
//  Created by yanwei on 2021/9/12.
//  Copyright © 2021 yanwei. All rights reserved.
// 加载字体

#ifndef FreeTypeLoad_hpp
#define FreeTypeLoad_hpp

#include <stdio.h>
#include <map>
#include <string>
#include "glad/glad.h"
#include <glm/glm.hpp>
#include <ft2build.h>
#include "Shader.hpp"
#include FT_FREETYPE_H

using namespace std;
/// Holds all state information relevant to a character as loaded using FreeType
struct Character {
    unsigned int TextureID; // ID handle of the glyph texture
    glm::ivec2   Size;      // Size of glyph
    glm::ivec2   Bearing;   // Offset from baseline to left/top of glyph
    unsigned int Advance;   // Horizontal offset to advance to next glyph
};

class FreeTypeLoad{
public:
    std::map<GLchar, Character> Characters;
    FT_Library ft;
    FreeTypeLoad(string font_name);
    void loadCharacter(string font_name);
    void RenderText(Shader &shader, std::string text, float x, float y, float scale, glm::vec3 color);
private:
    unsigned int VAO,VBO,EBO;
    void setupMesh();
};


#endif /* FreeTypeLoad_hpp */
