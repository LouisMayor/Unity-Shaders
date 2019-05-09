Shader "Unlit/Highlight"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 localVertex : TEXCOORD1;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.localVertex = v.vertex;
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				float val = clamp( cos( (_Time.z * 4.0) - i.localVertex.y), 0.0f, 1.0f );

				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);

				fixed4 outCol = lerp( col, fixed4(1.0f, 1.0f, 0.0f, 1.0f), val );

				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, outCol );
				return outCol;
			}
			ENDCG
		}
	}
}
