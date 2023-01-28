//
//  LightSpot.hpp
//  OpenGLProject
//
//  Created by yanwei on 2021/4/11.
//  Copyright © 2021 yanwei. All rights reserved.
//

#ifndef LightSpot_hpp
#define LightSpot_hpp

#include <stdio.h>
#include <glm/glm.hpp>
#include <glm/gtx/rotate_vector.hpp>
#include "Shader.hpp"
#include "Light.hpp"

struct LightSpotInfo
{
    //colors
    glm::vec3 ambient;
    glm::vec3 diffuse;
    glm::vec3 specular;
    
    glm::vec3 position;
    glm::vec3  direction;
    float cutOff;//内圆锥
    float outerCutOff;//外圆锥
};

class LightSpot {
public:
    LightSpot(Shader &_shader, LightSpotInfo &_info);
    ~LightSpot();
    
    LightSpotInfo &info;
    Shader &shader;
    
    //设置uniform参数
    void setLightUniform();
};
#endif /* LightSpot_hpp */
