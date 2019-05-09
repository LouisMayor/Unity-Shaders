Shader "Unlit/Dissolve"
{
	Properties
	{
		_MainTex( "Texture", 2D ) = "white" {}
		_DissolveTexture( "Dissolve Tex", 2D ) = "white" {}
		_Amount( "Amount", Range( 0,1 ) ) = 0
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }
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
					UNITY_FOG_COORDS( 1 )
					float4 vertex : SV_POSITION;
				};

				sampler2D _MainTex;
				float4 _MainTex_ST;

				sampler2D _DissolveTexture;
				half _Amount;

				v2f vert( appdata v )
				{
					v2f o;
					o.vertex = UnityObjectToClipPos( v.vertex );
					o.uv = TRANSFORM_TEX( v.uv, _MainTex );
					UNITY_TRANSFER_FOG( o,o.vertex );
					return o;
				}

				fixed4 frag( v2f i ) : SV_Target
				{
					_Amount = 1 + cos( _Time.z * 0.6 );

					half alphaDissolve = tex2D( _DissolveTexture, i.uv ).r;
				    clip( alphaDissolve - _Amount );

					// sample the texture
					fixed4 col = tex2D( _MainTex, i.uv );
					// apply fog
					UNITY_APPLY_FOG( i.fogCoord, col );
					return col;
				}
				ENDCG
			}
		}
}
