#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal;

out vec3 Normal;
out vec3 Position;

out VS_OUT
{
    vec3 normal;
    vec3 position;
} vs_out;

uniform mat4 modelMat;
uniform mat4 viewMat;
uniform mat4 projMat;

void main()
{
    Normal = mat3(transpose(inverse(modelMat))) * aNormal;
    Position = vec3(modelMat * vec4(aPos, 1.0));//世界坐标
    vs_out.normal = Normal;
    vs_out.position = Position;
    gl_Position = projMat * viewMat * modelMat * vec4(aPos, 1.0);
}
