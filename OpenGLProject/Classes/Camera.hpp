//
//  Camera.hpp
//  OpenGLProject
//
//  Created by yanwei on 2021/2/28.
//  Copyright © 2021 yanwei. All rights reserved.
//

#ifndef Camera_hpp
#define Camera_hpp

#include <stdio.h>
//glm
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

const float YAW         = -90.0f;
const float PITCH       =  0.0f;
const float SPEED       =  2.5f;
const float SENSITIVITY =  0.01f;
const float ZOOM        =  45.0f;
enum Camera_Movement {
    FORWARD,
    BACKWARD,
    LEFT,
    RIGHT,
    UP,
    BOTTOM
};

class Camera{
public:
    Camera(glm::vec3 position, glm::vec3 target, glm::vec3 worldup);
    //欧拉角的方式
    Camera(glm::vec3 position, float pitch, float yaw, glm::vec3 worldup);
    ~Camera();
    //摄像机位置
    glm::vec3 Position;
    //摄像机三个方向
    glm::vec3 Forward;
    glm::vec3 Right;
    glm::vec3 Up;
    //世界坐标上方
    glm::vec3 WorldUp;
    float Pitch;//俯仰角
    float Yaw;//偏航角
    float MouseSensitivity = SENSITIVITY;//鼠标的灵敏度
    float MovementSpeed = SPEED;//移动速度
    
    //Look At 矩阵
    glm::mat4 GetViewMatrix();
    //处理鼠标输入
    void ProcessMouseMovement(float deltaX, float deltaY, bool constrainPitch = true);
    //处理键盘
    void ProcessKeyboard(Camera_Movement direction, float deltaTime);
private:
    void updateCameraVectors();
};

#endif /* Camera_hpp */
