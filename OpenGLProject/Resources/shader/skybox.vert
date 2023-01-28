#version 330 core
layout (location = 0) in vec3 aPos;

out vec3 TexCoords;

uniform mat4 projMat;
uniform mat4 viewMat;
uniform mat4 modelMat;

void main()
{
    TexCoords = aPos;
    vec4 pos = projMat * viewMat * projMat * vec4(aPos, 1.0);
    //优化skybox的深度始终为最大值1，只要前边有物体就不渲染
    gl_Position = pos.xyww;
}
