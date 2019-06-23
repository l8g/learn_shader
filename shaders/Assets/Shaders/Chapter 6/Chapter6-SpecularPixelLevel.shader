
Shader "Chapter 6/Specular/Pixel Level" {
    properties {
        _Diffuse("Diffuse", Color) = (1, 1, 1, 1)
        _Speclar("Speclar", Color) = (1, 1, 1, 1)
        _Gloss("Gloss", Range(8, 256)) = 20
    }

    SubShader {
        Pass {
            Tags {"LightMode" = "ForwardBase"}

            CGPROGRAM

            #include "Lighting.cginc"
            #pragma vertex vert
            #pragma fragment frag

            fixed3 _Diffuse;
            fixed3 _Speclar;
            float _Gloss;

            struct a2v {
                float4 veretex : POSITION;
                fixed3 normal : NORMAL;
            };

            struct v2f {
                float4 pos : SV_POSITION;
                fixed3 worldNormal : TEXCOORD0;
                float4 worldPos : TEXCOORD1;
            };

            v2f vert (a2v v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.veretex);
                o.worldPos = mul(unity_ObjectToWorld, v.veretex);
                o.worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET {
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldLight, i.worldNormal));

                fixed3 reflectDir = normalize(reflect(-worldLight, i.worldNormal));
                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);

                fixed3 speclar = _LightColor0.rgb * _Speclar.rgb * pow(saturate(dot(reflectDir, viewDir)), _Gloss);

                fixed3 color = ambient + diffuse + speclar;

                return fixed4(color, 1.0);
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}