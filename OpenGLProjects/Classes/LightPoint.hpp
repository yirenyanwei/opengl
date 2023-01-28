//
//  LightPoint.hpp
//  OpenGLProject
//
//  Created by yanwei on 2021/4/11.
//  Copyright © 2021 yanwei. All rights reserved.
//

#ifndef LightPoint_hpp
#define LightPoint_hpp

#include <stdio.h>
#include <glm/glm.hpp>
#include <glm/gtx/rotate_vector.hpp>
#include "Shader.hpp"
#include "Light.hpp"

struct LightPointInfo
{
    //colors
    glm::vec3 ambient;
    glm::vec3 diffuse;
    glm::vec3 specular;
    
    glm::vec3 position;
    float constant;
    float linear;
    float quadratic;
};

class LightPoint {
public:
    LightPoint(Shader &_shader, LightPointInfo &_info);
    ~LightPoint();
    
    LightPointInfo &info;
    Shader &shader;
    
    //设置uniform参数
    void setLightUniform(string title);
};
#endif /* LightPoint_hpp */
