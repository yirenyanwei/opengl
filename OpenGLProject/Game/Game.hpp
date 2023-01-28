//
//  Game.hpp
//  OpenGLProject
//
//  Created by yanwei on 2021/9/27.
//  Copyright © 2021 yanwei. All rights reserved.
//  控制整个游戏的流程 包括初始化、更新、渲染等
//

#ifndef Game_hpp
#define Game_hpp

#include <stdio.h>
#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include "GameLevel.hpp"

// Represents the current state of the game
enum GameState {
    GAME_ACTIVE,
    GAME_MENU,
    GAME_WIN
};

// Initial size of the player paddle 挡板的尺寸
const glm::vec2 PLAYER_SIZE(100.0f, 20.0f);
// Initial velocity of the player paddle 挡板的速度
const float PLAYER_VELOCITY(500.0f);


// Game holds all game-related state and functionality.
// Combines all game-related data into a single class for
// easy access to each of the components and manageability.
class Game
{
public:
    // game state
    GameState               State;
    bool                    Keys[1024];//按下某一个按键
    unsigned int            Width, Height;
    std::vector<GameLevel> Levels;//关卡
    unsigned int           Level;//当前关卡
    // constructor/destructor
    Game(unsigned int width, unsigned int height);
    ~Game();
    // initialize game state (load all shaders/textures/levels)
    void Init();
    // game loop
    void ProcessInput(float dt);
    void Update(float dt);
    void Render();
};

#endif /* Game_hpp */
