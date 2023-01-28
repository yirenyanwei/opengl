//
//  Light.cpp
//  OpenGLProject
//  灯光
//  Created by yanwei on 2021/3/21.
//  Copyright © 2021 yanwei. All rights reserved.
//

#include "Light.hpp"

Light::Light(Shader &_shader, LightInfo &_info):
shader(_shader),
lightInfo(_info)
{
    
}
Light::~Light()
{
    
}

void Light::setLightUniform()
{
    shader.setInt("light.type", 0);
    shader.setVec3("light.position",  lightInfo.position);
    shader.setVec3("light.ambient",  lightInfo.ambient);
    shader.setVec3("light.diffuse",  lightInfo.diffuse);
    shader.setVec3("light.specular", lightInfo.specular);
}

void Light::setTimeTransform(float timeValue)
{
    glm::vec3 lightColor;
    lightColor.x = sin(timeValue * 2.0f);
    lightColor.y = sin(timeValue * 0.7f);
    lightColor.z = sin(timeValue * 1.3f);

    glm::vec3 diffuseColor = lightColor   * glm::vec3(0.5f); // 降低影响
    glm::vec3 ambientColor = diffuseColor * glm::vec3(0.2f); // 很低的影响

    lightInfo.ambient = ambientColor;
    lightInfo.diffuse = diffuseColor;
}
