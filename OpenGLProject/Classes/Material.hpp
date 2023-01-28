//
//  Material.hpp
//  OpenGLProject
//
//  Created by yanwei on 2021/3/21.
//  Copyright © 2021 yanwei. All rights reserved.
//

#ifndef Material_hpp
#define Material_hpp

#include <stdio.h>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#include "Shader.hpp"

struct MaterialInfo{
    glm::vec3 ambient;
    glm::uint diffuse;
    glm::uint specular;
    glm::uint emmision;
    float shininess;
};
class Material{
public:
    Material(Shader &_shader, MaterialInfo &_info);
    ~Material();
    Shader &shader;
    MaterialInfo &materialInfo;
    // 设置材质参数
    void setMaterialUniform();
};

#endif /* Material_hpp */
