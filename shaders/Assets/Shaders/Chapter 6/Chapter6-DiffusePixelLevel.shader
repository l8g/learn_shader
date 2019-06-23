
Shader "Chapter 6/Diffuse/Pixel Level" {
    properties {
        _Diffuse ("Diffuse", Color) = (1, 1, 1, 1)
    }

    SubShader {
        Pass {
            Tags {"LightMode" = "ForwardBase"}
            
            CGPROGRAM
            #include "Lighting.cginc"
            #pragma vertex vert
            #pragma fragment frag

            fixed3 _Diffuse;

            struct a2v {
                float4 vertex : POSITION;
                fixed3 normal : NORMAL;
            };

            struct v2f {
                float4 pos : SV_POSITION;
                fixed3 worldNormal : TEXCOORD0;
            };

            v2f vert (a2v v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));

                return o;
            }

            fixed4 frag (v2f i) : SV_TARGET {
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz); // 这里看起来是光源位置，不像是当前片元指向光源的向量

                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldLight, i.worldNormal));

                fixed3 color = diffuse + ambient;

                return fixed4(color, 1.0); 
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}