//
//  GameLevel.hpp
//  OpenGLProject
//
//  Created by yanwei on 2021/9/27.
//  Copyright © 2021 yanwei. All rights reserved.
//  砖块的集合表示一个关卡
/**
 1 1 1 1 1 1
 2 2 0 0 2 2
 3 3 4 4 3 3
 数字0：无砖块，表示关卡中空的区域
 数字1：一个坚硬的砖块，不可被摧毁
 大于1的数字：一个可被摧毁的砖块，不同的数字区分砖块的颜色
 */

#ifndef GameLevel_hpp
#define GameLevel_hpp

#include <stdio.h>
#include <vector>

#include <glad/glad.h>
#include <glm/glm.hpp>

#include "GameObject.hpp"
#include "SpriteRenderer.hpp"
#include "ResourceManager.hpp"


/// GameLevel holds all Tiles as part of a Breakout level and
/// hosts functionality to Load/render levels from the harddisk.
class GameLevel
{
public:
    // level state
    std::vector<GameObject> Bricks;
    // constructor
    GameLevel() { }
    // loads level from file
    void Load(const char *file, unsigned int levelWidth, unsigned int levelHeight);
    // render level
    void Draw(SpriteRenderer &renderer);
    // check if the level is completed (all non-solid tiles are destroyed)
    bool IsCompleted();
private:
    // initialize level from tile data
    void init(std::vector<std::vector<unsigned int>> tileData, unsigned int levelWidth, unsigned int levelHeight);
};


#endif /* GameLevel_hpp */
