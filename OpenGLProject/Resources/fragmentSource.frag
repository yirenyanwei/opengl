#version 330 core
out vec4 FragColor;

in vec4 vectexColor;
in vec2 TexCoord;

uniform vec4 ourColor;
//一个纹理的默认纹理单元是0，它是默认的激活纹理单元, 不用用户传入
uniform sampler2D ourTexture;
uniform sampler2D ourTextureB;

//光照
uniform vec3 objColor;//物体颜色
uniform vec3 ambientColor;//环境光
uniform vec3 lightPos;//灯光位置
uniform vec3 lightColor;//灯光颜色
uniform vec3 viewPos;//眼睛的位置
in vec3 FragPos;
in vec3 Normal;

//Material
struct Material{
    vec3 ambient;
//    vec3 diffuse;
    sampler2D diffuse;
    sampler2D specular;
    sampler2D emission;

    float shininess;
};
uniform Material material;

//三种光源单独定义
struct LightDirectional{
    //颜色
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
    
    vec3 direction;//方向
};
uniform LightDirectional lightD;

struct LightPoint{
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
    
    vec3 position;
    float constant;
    float linear;
    float quadratic;
};
#define NR_POINT_LIGHTS 4
uniform LightPoint lightPoints[NR_POINT_LIGHTS];

struct LightSpot{
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
    
    vec3 position;
    vec3 direction;
    float cutOff;
    float outerCutOff;
};
uniform LightSpot lightS;

vec3 CalcLightDirectional(LightDirectional light, vec3 norm, vec3 viewDir){
    //环境光
    vec3 ambient = light.ambient*texture(material.diffuse, TexCoord).rgb;//环境光,暗处也能看见木箱
    //漫反射
    vec3 lightDir = normalize(light.direction);
    float diff = max(dot(lightDir, norm), 0.0);// 夹角即反射强度 >0  防止影响其他部分光
    vec3 diffuse = light.diffuse * diff * vec3(texture(material.diffuse, TexCoord));
    //计算镜面反射
    vec3 reflectDir = reflect(-lightDir, norm);//反射的方向
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);//32是高光的反光度(Shininess)
    vec3 specular = light.specular*spec*texture(material.specular, TexCoord).rgb;
    
    // 自发光 emission 暂时屏蔽掉
    vec3 emission = texture(material.emission, TexCoord).rgb*vec3(0.0, 0.0, 0.0);
    
    vec3 result = (ambient+diffuse+specular+emission);//环境光+漫反射+镜面反射
    return result;
}

vec3 CalcLightPoint(LightPoint light, vec3 norm, vec3 fragPos, vec3 viewDir){
    // 光照
    vec3 ambient = light.ambient*texture(material.diffuse, TexCoord).rgb;//环境光,暗处也能看见木箱
    vec3 lightDir = normalize(light.position - fragPos); //光线的单位向量  物体->光的方向
    //漫反射
    float diff = max(dot(lightDir, norm), 0.0);// 夹角即反射强度 >0  防止影响其他部分光
    vec3 diffuse = light.diffuse * diff * vec3(texture(material.diffuse, TexCoord));
    //计算镜面反射
    vec3 reflectDir = reflect(-lightDir, norm);//反射的方向
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);//32是高光的反光度(Shininess)
    vec3 specular = light.specular*spec*texture(material.specular, TexCoord).rgb;
    
    // 自发光 emission 暂时屏蔽掉
    vec3 emission = texture(material.emission, TexCoord).rgb*vec3(0.0, 0.0, 0.0);
    
    //点光源衰减
    float distance    = length(light.position - fragPos);
    float attenuation = 1.0 / (light.constant + light.linear * distance +
                    light.quadratic * (distance * distance));
    ambient  *= attenuation;
    diffuse  *= attenuation;
    specular *= attenuation;
    
    vec3 result = (ambient+diffuse+specular+emission);//环境光+漫反射+镜面反射
    return result;
}

vec3 CalcLightSpot(LightSpot light, vec3 norm, vec3 fragPos, vec3 viewDir){
    vec3 ambient = light.ambient*texture(material.diffuse, TexCoord).rgb;//环境光,暗处也能看见木箱
    vec3 lightDir = normalize(light.position - fragPos); //光线的单位向量  物体->光的方向
    //漫反射
    float diff = max(dot(lightDir, norm), 0.0);// 夹角即反射强度 >0  防止影响其他部分光
    vec3 diffuse = light.diffuse * diff * vec3(texture(material.diffuse, TexCoord));
    //计算镜面反射
    vec3 reflectDir = reflect(-lightDir, norm);//反射的方向
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);//32是高光的反光度(Shininess)
    vec3 specular = light.specular*spec*texture(material.specular, TexCoord).rgb;
    
    // 自发光 emission 暂时屏蔽掉
    vec3 emission = texture(material.emission, TexCoord).rgb*vec3(0.0, 0.0, 0.0);
    
    //聚光灯判断范围
    float theta     = dot(lightDir, normalize(-light.direction));//当前照射点与方向的余弦
    float epsilon   = light.cutOff - light.outerCutOff;//內圆外圆余弦差
    float intensity = clamp((theta - light.outerCutOff) / epsilon, 0.0, 1.0);//限制到（0，1）
    // 将不对环境光做出影响，让它总是能有一点光
    diffuse  *= intensity;
    specular *= intensity;
    
    vec3 result = (ambient+diffuse+specular+emission);
    return result;
}

float near = 0.1;
float far  = 100.0;
//测试z轴的线性变化
float LinearizeDepth(float depth)
{
    float z = depth * 2.0 - 1.0; // back to NDC  -1~1
    return (2.0 * near * far) / (far + near - z * (far - near));
}

void main(){
    // 属性
    vec3 norm = normalize(Normal);
    vec3 viewDir = normalize(viewPos - FragPos);//眼睛的方向
    //结果
    vec3 result = vec3(0, 0, 0);
    //平行光
    result += CalcLightDirectional(lightD, norm, viewDir);
    //点光源
    for(int i = 0; i<NR_POINT_LIGHTS; i++){
        result += CalcLightPoint(lightPoints[i], norm, FragPos, viewDir);
    }
    //聚光
    result += CalcLightSpot(lightS, norm, FragPos, viewDir);
    FragColor = vec4(result, 1.0);
    
    //测试z轴的变化
//    FragColor = vec4(vec3(gl_FragCoord.z), 1.0);
//    float depth = LinearizeDepth(gl_FragCoord.z) / far; // 为了演示除以 far
//    FragColor = vec4(vec3(depth), 1.0);
}

//Light
struct Light {
    int type;//0通用 1平行光 2点光源
    //颜色
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
    //平行光的方向
    vec3 direction;
    //点光源
    vec3 position;
    float constant;
    float linear;
    float quadratic;
    //聚光
//    vec3 position;
//    vec3 direction;
    float cutOff;
    float outerCutOff;
};
uniform Light light;
void mainOld(){
    //FragColor=vec4(1.0,0.5,0.0,1.0);//直接赋值
    //FragColor = vectexColor;//从定点着色器中传值
    //FragColor = ourColor;//从cup中输入全局变量的值
    //处理图片 去ourTexture图片的TexCoord纹理坐标
    // FragColor = texture(ourTexture, TexCoord) * ourColor;//变色的箱子
    
    //箱子 + 笑脸
    // FragColor = mix(texture(ourTexture, TexCoord), texture(ourTextureB, TexCoord), 0.2);//图片叠加
    
    // 光照
    // float ambientStrength = 0.1;
    vec3 ambient = light.ambient*texture(material.diffuse, TexCoord).rgb;//环境光,暗处也能看见木箱
    vec3 lightDir;
    if(light.type==0 || light.type==2 || light.type==3){
        lightDir = normalize(light.position - FragPos); //光线的单位向量  物体->光的方向
    }else if(light.type==1){
        lightDir = normalize(light.direction);
    }
    vec3 norm = normalize(Normal);
    //漫反射
    float diff = max(dot(lightDir, norm), 0.0);// 夹角即反射强度 >0  防止影响其他部分光
//    vec3 diffuse = light.diffuse*(diff*material.diffuse);// 漫反射光
    vec3 diffuse = light.diffuse * diff * vec3(texture(material.diffuse, TexCoord));
    //计算镜面反射
    vec3 viewDir = normalize(viewPos-FragPos);//眼睛的方向
    vec3 reflectDir = reflect(-lightDir, norm);//反射的方向
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);//32是高光的反光度(Shininess)
    // float specularStrength = 0.5;//高光强度
//    vec3 specular = light.specular*(spec*material.specular);
    vec3 specular = light.specular*spec*texture(material.specular, TexCoord).rgb;
    
    // 自发光 emission 暂时屏蔽掉
    vec3 emission = texture(material.emission, TexCoord).rgb*vec3(0.0, 0.0, 0.0);
    
    if(light.type==2){
        //点光源衰减
        float distance    = length(light.position - FragPos);
        float attenuation = 1.0 / (light.constant + light.linear * distance +
                        light.quadratic * (distance * distance));
        ambient  *= attenuation;
        diffuse  *= attenuation;
        specular *= attenuation;
    }else if(light.type==3){
        //聚光灯判断范围
        float theta     = dot(lightDir, normalize(-light.direction));//当前照射点与方向的余弦
        float epsilon   = light.cutOff - light.outerCutOff;//內圆外圆余弦差
        float intensity = clamp((theta - light.outerCutOff) / epsilon, 0.0, 1.0);//限制到（0，1）
        // 将不对环境光做出影响，让它总是能有一点光
        diffuse  *= intensity;
        specular *= intensity;
    }
    vec3 result = (ambient+diffuse+specular+emission)*objColor;//环境光+漫反射+镜面反射
    FragColor = vec4(result, 1.0);
    
}
