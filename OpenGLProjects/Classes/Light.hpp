//
//  Light.hpp
//  OpenGLProject
//
//  Created by yanwei on 2021/3/21.
//  Copyright © 2021 yanwei. All rights reserved.
//

#ifndef Light_hpp
#define Light_hpp

#include <stdio.h>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#include "Shader.hpp"

struct LightInfo {
    glm::vec3 position;

    glm::vec3 ambient;
    glm::vec3 diffuse;
    glm::vec3 specular;
};
class Light
{
public:
    Light(Shader &_shader, LightInfo &_info);
    ~Light();
    Shader &shader;
    LightInfo &lightInfo;
    //设置随时间p变换
    void setTimeTransform(float timeValue);
    //设置uniform参数
    void setLightUniform();
};

#endif /* Light_hpp */
