//
//  Camera.cpp
//  OpenGLProject
//
//  Created by yanwei on 2021/2/28.
//  Copyright © 2021 yanwei. All rights reserved.
//

#include "Camera.hpp"

Camera::Camera(glm::vec3 position, glm::vec3 target, glm::vec3 worldup){
    WorldUp = worldup;
    Position = position;
    //转成单位向量
    Forward = glm::normalize(target-position);//摄像机方向
    //叉乘前方与世界的上方
    Right = glm::normalize(glm::cross(WorldUp, Forward));
    //叉乘右方与前方才是正方向
    Up = glm::normalize(glm::cross(Right, Forward));
    
}

Camera::Camera(glm::vec3 position, float pitch, float yaw, glm::vec3 worldup){
    Position = position;
    WorldUp = worldup;
    
    Pitch = pitch;
    Yaw = yaw;
    updateCameraVectors();
}

Camera::~Camera(){
    
}

glm::mat4 Camera::GetViewMatrix(){
    // 相机位置 target 世界上方
    return glm::lookAt(Position, Position+Forward, WorldUp);
}

void Camera::updateCameraVectors(){
    //计算前向量
    Forward.x = glm::cos(Pitch)*glm::sin(Yaw);
    Forward.y = glm::sin(Pitch);
    Forward.z = glm::cos(Pitch)*glm::cos(Yaw);
    Forward = glm::normalize(Forward);
    
    //叉乘前方与世界的上方
    Right = glm::normalize(glm::cross(WorldUp, Forward));
    //叉乘右方与前方才是正方向
    Up = glm::normalize(glm::cross(Right, Forward));
}

void Camera::ProcessMouseMovement(float deltaX, float deltaY, bool constrainPitch){
    //鼠标输入 xoffset x轴的偏移
    deltaX *= MouseSensitivity;
    deltaY *= MouseSensitivity;

    Yaw   += deltaX;
    Pitch += deltaY;
    // make sure that when pitch is out of bounds, screen doesn't get flipped
    if (constrainPitch)
    {
        if (Pitch > 89.0f)
            Pitch = 89.0f;
        if (Pitch < -89.0f)
            Pitch = -89.0f;
    }
    
    updateCameraVectors();
}

void Camera::ProcessKeyboard(Camera_Movement direction, float deltaTime)
{
    float velocity = MovementSpeed * deltaTime;
    if (direction == FORWARD)
        Position += Forward * velocity;
    if (direction == BACKWARD)
        Position -= Forward * velocity;
    if (direction == LEFT)
        Position -= Right * velocity;
    if (direction == RIGHT)
        Position += Right * velocity;
    if (direction == UP)
        Position += Up * velocity;
    if (direction == BOTTOM)
        Position -= Up * velocity;
}
