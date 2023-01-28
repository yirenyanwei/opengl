
#version 330 core
layout (triangles) in;
layout (triangle_strip, max_vertices = 3) out;


uniform float time;

in VS_OUT{
    vec2 TexCoord;
    vec4 vectexColor;
    vec3 FragPos;
    vec3 Normal;
} gs_in[];

out vec2 TexCoord;
out vec4 vectexColor;
out vec3 FragPos;
out vec3 Normal;

vec4 explode(vec4 position, vec3 normal)
{
    //爆炸效果
    float magnitude = 2.0;
    vec3 direction = normal * ((sin(time) + 1.0) / 2.0) * magnitude;
    return position + vec4(direction, 0.0);
}

vec3 GetNormal()
{
    //叉乘获取法向量
    vec3 a = vec3(gl_in[0].gl_Position) - vec3(gl_in[1].gl_Position);
    vec3 b = vec3(gl_in[2].gl_Position) - vec3(gl_in[1].gl_Position);
    return normalize(cross(a, b));
}

void main() {
    vec3 normal = GetNormal();

    gl_Position = explode(gl_in[0].gl_Position, normal);
    TexCoord = gs_in[0].TexCoord;
    vectexColor = gs_in[0].vectexColor;
    FragPos = gs_in[0].FragPos;
    Normal = gs_in[0].Normal;
    EmitVertex();
    gl_Position = explode(gl_in[1].gl_Position, normal);
    TexCoord = gs_in[1].TexCoord;
    vectexColor = gs_in[1].vectexColor;
    FragPos = gs_in[1].FragPos;
    Normal = gs_in[1].Normal;
    EmitVertex();
    gl_Position = explode(gl_in[2].gl_Position, normal);
    TexCoord = gs_in[2].TexCoord;
    vectexColor = gs_in[2].vectexColor;
    FragPos = gs_in[2].FragPos;
    Normal = gs_in[2].Normal;
    EmitVertex();
    EndPrimitive();
}
