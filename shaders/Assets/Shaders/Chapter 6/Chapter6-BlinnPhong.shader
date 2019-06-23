// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Chapter 6/Specular/BlinnPhong" {

	properties {
		_Diffuse ("Diffuse", Color) = (1, 1, 1, 1)
		_Specular ("Specular", Color) = (1, 1, 1, 1)
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
			fixed3 _Specular;
			float _Gloss;

			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float3 worldPos : TEXCOORD0;
				fixed3 worldNormal : TEXCOORD1;
			};

			

			v2f vert (a2v v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);

				o.worldNormal = normalize(UnityObjectToWorldNormal(v.normal));
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);

				return o;
			}

			fixed4 frag (v2f i) : SV_TARGET {
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

				fixed3 worldLight = normalize(UnityWorldSpaceLightDir(i.worldPos));

				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldLight, i.worldNormal));

				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));

				fixed3 blinn = normalize(viewDir + worldLight);

				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(i.worldNormal, blinn)), _Gloss);

				fixed3 color =  ambient + diffuse + specular;

				return fixed4(color, 1.0);	
			}


			ENDCG
		}
	}

	Fallback "Diffuse"
}