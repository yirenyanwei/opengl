//
//  GameObject.hpp
//  OpenGLProject
//
//  Created by yanwei on 2021/9/27.
//  Copyright © 2021 yanwei. All rights reserved.
//  游戏对象例如砖块，记录着物体的各种状态，如其位置、大小与速率。
//  它还持有颜色、旋转、是否坚硬(不可被摧毁)、是否被摧毁的属性，除此之外，它还存储了一个Texture2D变量作为其精灵(Sprite)

#ifndef GameObject_hpp
#define GameObject_hpp

#include <stdio.h>
#include <glad/glad.h>
#include <glm/glm.hpp>

#include "Texture2D.hpp"
#include "SpriteRenderer.hpp"


// Container object for holding all state relevant for a single
// game object entity. Each object in the game likely needs the
// minimal of state as described within GameObject.
class GameObject
{
public:
    // object state
    glm::vec2   Position, Size, Velocity;
    glm::vec3   Color;
    float       Rotation;
    bool        IsSolid;//是否坚硬（不可被摧毁）
    bool        Destroyed;//是否被摧毁
    // render state
    Texture2D   Sprite;
    // constructor(s)
    GameObject();
    GameObject(glm::vec2 pos, glm::vec2 size, Texture2D sprite, glm::vec3 color = glm::vec3(1.0f), glm::vec2 velocity = glm::vec2(0.0f, 0.0f));
    // draw sprite
    virtual void Draw(SpriteRenderer &renderer);
};
#endif /* GameObject_hpp */
