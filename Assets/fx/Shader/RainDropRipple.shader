// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RippleShader"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_RippleIntense("RippleIntense", Float) = 1
		_AlbedoTiling("AlbedoTiling", Float) = 1
		_Tint("Tint", Color) = (1,1,1,0)
		_Diffuseintense("Diffuse intense", Float) = 1
		_MFIntense("MFIntense", Float) = 1
		_RippleTiling("RippleTiling", Float) = 1
		_Speed("Speed", Float) = 9
		_Wetness("Wetness", Float) = 0.8
		_RipplesNormal("RipplesNormal", 2D) = "bump" {}
		_SpeedRippleMask("SpeedRippleMask", Float) = 1
		_NormalMap("NormalMap", 2D) = "bump" {}
		_Metall("Metall", Float) = 1
		_MaskStrenght("MaskStrenght", Range( 0 , 1)) = 1
		_Smootness("Smootness", 2D) = "white" {}
		_MetalTexture("MetalTexture", 2D) = "white" {}
		_AO("AO", Float) = 1
		[Toggle(_BLENDAOTOALBEDO_ON)] _BlendAOtoalbedo("Blend AO to albedo", Float) = 0
		_AOmap("AOmap", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature _BLENDAOTOALBEDO_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _NormalMap;
		uniform float _AlbedoTiling;
		uniform float _MFIntense;
		uniform sampler2D _RipplesNormal;
		uniform float _MaskStrenght;
		uniform float _SpeedRippleMask;
		uniform float _RippleTiling;
		uniform float _Speed;
		uniform float _RippleIntense;
		uniform sampler2D _Albedo;
		uniform float4 _Tint;
		uniform float _Diffuseintense;
		uniform sampler2D _AOmap;
		uniform sampler2D _MetalTexture;
		uniform float _Metall;
		uniform float _Wetness;
		uniform sampler2D _Smootness;
		uniform float _AO;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (_AlbedoTiling).xx;
			float2 uv_TexCoord146 = i.uv_texcoord * temp_cast_0;
			float2 AlbedoTiling147 = uv_TexCoord146;
			float3 break6_g16 = UnpackNormal( tex2D( _NormalMap, AlbedoTiling147 ) );
			float2 appendResult1_g16 = (float2(break6_g16.x , break6_g16.y));
			float3 appendResult4_g16 = (float3(( appendResult1_g16 * _MFIntense ) , break6_g16.z));
			float temp_output_61_0 = ( _Time.y * _SpeedRippleMask );
			float RippleTile14 = _RippleTiling;
			float2 panner53 = ( temp_output_61_0 * float2( 0.57,0.47 ) + ( i.uv_texcoord * RippleTile14 ));
			float simplePerlin2D48 = snoise( panner53 );
			float2 panner70 = ( temp_output_61_0 * float2( -0.57,-0.47 ) + ( i.uv_texcoord * RippleTile14 ));
			float simplePerlin2D71 = snoise( panner70 );
			float RippleMAsk62 = ( _MaskStrenght * ( simplePerlin2D48 * simplePerlin2D71 ) );
			float2 temp_cast_1 = (RippleTile14).xx;
			float2 uv_TexCoord2 = i.uv_texcoord * temp_cast_1;
			float2 appendResult11 = (float2(frac( uv_TexCoord2.x ) , frac( uv_TexCoord2.y )));
			float temp_output_4_0_g15 = 4.0;
			float temp_output_5_0_g15 = 4.0;
			float2 appendResult7_g15 = (float2(temp_output_4_0_g15 , temp_output_5_0_g15));
			float totalFrames39_g15 = ( temp_output_4_0_g15 * temp_output_5_0_g15 );
			float2 appendResult8_g15 = (float2(totalFrames39_g15 , temp_output_5_0_g15));
			float mulTime5 = _Time.y * _Speed;
			float clampResult42_g15 = clamp( 0.0 , 0.0001 , ( totalFrames39_g15 - 1.0 ) );
			float temp_output_35_0_g15 = frac( ( ( mulTime5 + clampResult42_g15 ) / totalFrames39_g15 ) );
			float2 appendResult29_g15 = (float2(temp_output_35_0_g15 , ( 1.0 - temp_output_35_0_g15 )));
			float2 temp_output_15_0_g15 = ( ( appendResult11 / appendResult7_g15 ) + ( floor( ( appendResult8_g15 * appendResult29_g15 ) ) / appendResult7_g15 ) );
			float2 temp_cast_2 = (( RippleTile14 / 0.7 )).xx;
			float2 uv_TexCoord19 = i.uv_texcoord * temp_cast_2 + float2( 1,0.42 );
			float2 appendResult22 = (float2(frac( uv_TexCoord19.x ) , frac( uv_TexCoord19.y )));
			float temp_output_4_0_g14 = 4.0;
			float temp_output_5_0_g14 = 4.0;
			float2 appendResult7_g14 = (float2(temp_output_4_0_g14 , temp_output_5_0_g14));
			float totalFrames39_g14 = ( temp_output_4_0_g14 * temp_output_5_0_g14 );
			float2 appendResult8_g14 = (float2(totalFrames39_g14 , temp_output_5_0_g14));
			float clampResult42_g14 = clamp( 0.0 , 0.0001 , ( totalFrames39_g14 - 1.0 ) );
			float temp_output_35_0_g14 = frac( ( ( mulTime5 + clampResult42_g14 ) / totalFrames39_g14 ) );
			float2 appendResult29_g14 = (float2(temp_output_35_0_g14 , ( 1.0 - temp_output_35_0_g14 )));
			float2 temp_output_15_0_g14 = ( ( appendResult22 / appendResult7_g14 ) + ( floor( ( appendResult8_g14 * appendResult29_g14 ) ) / appendResult7_g14 ) );
			float3 break177 = BlendNormals( UnpackScaleNormal( tex2D( _RipplesNormal, temp_output_15_0_g15 ), RippleMAsk62 ) , UnpackScaleNormal( tex2D( _RipplesNormal, temp_output_15_0_g14 ), RippleMAsk62 ) );
			float2 appendResult173 = (float2(break177.x , break177.y));
			float3 appendResult175 = (float3(( appendResult173 * _RippleIntense ) , break177.z));
			float3 RippleNormals34 = appendResult175;
			o.Normal = BlendNormals( appendResult4_g16 , RippleNormals34 );
			float4 temp_output_84_0 = ( ( tex2D( _Albedo, AlbedoTiling147 ) * _Tint ) * _Diffuseintense );
			float4 tex2DNode184 = tex2D( _AOmap, AlbedoTiling147 );
			#ifdef _BLENDAOTOALBEDO_ON
				float4 staticSwitch161 = ( tex2DNode184 * temp_output_84_0 );
			#else
				float4 staticSwitch161 = temp_output_84_0;
			#endif
			float4 Abedo85 = staticSwitch161;
			o.Albedo = Abedo85.rgb;
			o.Metallic = ( tex2D( _MetalTexture, AlbedoTiling147 ) * _Metall ).r;
			o.Smoothness = ( _Wetness * tex2D( _Smootness, AlbedoTiling147 ) ).r;
			o.Occlusion = ( tex2DNode184 * _AO ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15600
6.4;28.8;1523;790;2122.56;351.3439;2.033543;True;True
Node;AmplifyShaderEditor.CommentaryNode;15;-1701.633,-275.0969;Float;False;479.08;170.4525;Comment;2;14;3;RippleTile;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;40;-3859.052,-69.27694;Float;False;2575.345;809.4619;Comment;62;174;173;175;176;177;34;33;4;104;1;39;25;123;23;11;38;49;66;12;68;24;17;10;50;2;122;51;45;18;29;22;117;116;65;52;115;67;118;28;20;21;19;64;114;26;27;41;113;42;121;8;5;120;7;124;119;125;16;178;179;180;181;RippleNormals;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1651.633,-212.5195;Float;False;Property;_RippleTiling;RippleTiling;7;0;Create;True;0;0;False;0;1;60;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;14;-1462.553,-219.2444;Float;False;RippleTile;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;63;-2680.664,-1759.66;Float;False;1575.454;699.7885;Ripple Mask;17;78;62;77;75;48;71;70;53;56;61;72;55;59;74;73;58;60;Ripple Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;16;-3817.732,47.90448;Float;False;14;RippleTile;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;59;-2587.364,-1500.886;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-2630.664,-1412.552;Float;False;Property;_SpeedRippleMask;SpeedRippleMask;11;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;125;-3645.647,98.8008;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;58;-2616.224,-1588.422;Float;False;14;RippleTile;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;74;-2621.54,-1288.328;Float;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;73;-2634.953,-1163.496;Float;False;14;RippleTile;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;55;-2602.811,-1709.66;Float;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;119;-3652.191,140.6923;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-2373.808,-1644.078;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-2422.005,-1486.977;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-2390.741,-1190.404;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;124;-3749.066,155.0925;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;53;-2236.912,-1625.592;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.57,0.47;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;70;-2234.635,-1337.685;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.57,-0.47;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;120;-3751.683,173.42;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;48;-2039.578,-1632.225;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-3553.333,200.5413;Float;False;Property;_Speed;Speed;8;0;Create;True;0;0;False;0;9;9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;71;-2037.301,-1344.318;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-1743.812,-1444.281;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-1808.305,-1543.211;Float;False;Property;_MaskStrenght;MaskStrenght;14;0;Create;True;0;0;False;0;1;0.594;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;121;-3756.92,287.3124;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;5;-3362.885,211.8092;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;8;-2938.886,255.0003;Float;True;Property;_RipplesNormal;RipplesNormal;10;0;Create;True;0;0;False;0;17ae57d8652469e49a436457fc6b6436;17ae57d8652469e49a436457fc6b6436;True;bump;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;41;-3685.146,271.9986;Float;False;2;0;FLOAT;0;False;1;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;27;-2490.969,324.4655;Float;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.WireNode;113;-3122.004,261.1301;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-1477.191,-1466.525;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;42;-3776.261,467.8803;Float;False;Constant;_Vector0;Vector 0;10;0;Create;True;0;0;False;0;1,0.42;0.97,0.42;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;62;-1322.436,-1473.248;Float;False;RippleMAsk;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-3534.689,444.9762;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.49,0.23;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;118;-3584.118,77.85501;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;26;-2482.676,357.6356;Float;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.WireNode;114;-3120.693,288.6215;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;-2660.187,197.8858;Float;False;62;RippleMAsk;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;67;-2403.187,235.8858;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;115;-3118.075,598.88;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;117;-3578.881,46.43642;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;52;-3125.636,238.23;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;21;-3271.375,439.2244;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;20;-3272.676,534.1247;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;28;-2480.603,475.8041;Float;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-3479.3,-13.52504;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;22;-3145.275,463.9244;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;29;-2470.236,496.5358;Float;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.WireNode;51;-3091.646,226.8997;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;65;-2404.187,253.8858;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;116;-3105.068,623.7533;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;122;-2409.847,539.9711;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;50;-3097.311,136.2575;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;24;-2490.969,299.5878;Float;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.WireNode;68;-2412.187,219.8858;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;12;-3217.285,75.62319;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;10;-3221.221,-19.27694;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;18;-2970.637,508.9897;Float;False;Flipbook;-1;;14;53c2488c220f6564ca6c90721ee16673;2,71,0,68,0;8;51;SAMPLER2D;0.0;False;13;FLOAT2;0,0;False;4;FLOAT;4;False;5;FLOAT;4;False;24;FLOAT;0;False;2;FLOAT;0;False;55;FLOAT;0;False;70;FLOAT;0;False;5;COLOR;53;FLOAT2;0;FLOAT;47;FLOAT;48;FLOAT;62
Node;AmplifyShaderEditor.WireNode;45;-2421.83,499.4806;Float;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.DynamicAppendNode;11;-3088.713,4.249885;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;23;-2453.636,283.9399;Float;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.WireNode;49;-3063.319,133.4249;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;66;-2402.187,202.8858;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;-2360.856,468.364;Float;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;123;-2403.302,93.56475;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;38;-2073.623,479.2522;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;25;-2455.724,67.39667;Float;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.FunctionNode;1;-2913.678,5.377929;Float;False;Flipbook;-1;;15;53c2488c220f6564ca6c90721ee16673;2,71,0,68,0;8;51;SAMPLER2D;0.0;False;13;FLOAT2;0,0;False;4;FLOAT;4;False;5;FLOAT;4;False;24;FLOAT;0;False;2;FLOAT;0;False;55;FLOAT;0;False;70;FLOAT;0;False;5;COLOR;53;FLOAT2;0;FLOAT;47;FLOAT;48;FLOAT;62
Node;AmplifyShaderEditor.SamplerNode;4;-2349.231,3.163013;Float;True;Property;_FlipBook;FlipBook;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;39;-2073.924,398.3863;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;181;-2063.472,186.4138;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;104;-2053.771,380.259;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendNormalsNode;33;-1889.748,329.4755;Float;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;145;-2995.98,-520.8138;Float;False;Property;_AlbedoTiling;AlbedoTiling;2;0;Create;True;0;0;False;0;1;29.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;179;-1754.902,266.1567;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;146;-2807.48,-520.814;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;180;-2023.601,132.6739;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;147;-2514.089,-525.3745;Float;False;AlbedoTiling;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;148;-1033.666,33.79427;Float;False;147;AlbedoTiling;0;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;184;-678.7755,660.0699;Float;True;Property;_AOmap;AOmap;19;0;Create;True;0;0;False;0;None;b7051b1a7ebcda3459e524ec5f457f67;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;177;-2023.935,11.57204;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.WireNode;188;-393.781,628.0754;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;174;-1769.129,106.5804;Float;False;Property;_RippleIntense;RippleIntense;1;0;Create;True;0;0;False;0;1;2.82;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;173;-1763.209,2.439088;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;100;-2213.133,-872.0831;Float;False;1733.143;546.7772;Comment;10;161;85;84;83;81;82;80;162;185;187;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;189;-875.731,560.9685;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;126;-742.9573,-140.5911;Float;True;Property;_NormalMap;NormalMap;12;0;Create;True;0;0;False;0;None;18fcd4e0ba40b074a9871e22891b2ccf;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;176;-1619.879,4.271545;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;186;-1142.125,135.9579;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;82;-2076.084,-628.0886;Float;False;Property;_Tint;Tint;3;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;169;-381.8263,-165.7098;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;80;-2163.133,-822.0831;Float;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;False;0;None;a561189d37e684f4c9d9a520cc216ed2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;175;-1485.241,4.175078;Float;False;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;187;-1133.99,-356.1595;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-1792.085,-713.0886;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-2059.084,-456.0888;Float;False;Property;_Diffuseintense;Diffuse intense;4;0;Create;True;0;0;False;0;1;1.89;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;168;-492.9323,-183.0701;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;178;-1676.892,278.2915;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;158;-459.05,-257.9379;Float;False;NormalIntense;5;;16;30562070d452005448884f54efb60ac5;0;1;5;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;185;-1481.727,-478.172;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-1662.871,325.39;Float;False;RippleNormals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-1613.085,-623.0886;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;-666.9791,140.599;Float;False;34;RippleNormals;0;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;137;-380.8939,151.9974;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;162;-1436.174,-592.8715;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;170;-185.657,-148.4467;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;161;-1341.999,-784.902;Float;False;Property;_BlendAOtoalbedo;Blend AO to albedo;18;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;152;-340.613,292.8141;Float;False;Property;_Metall;Metall;13;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;159;-363.3008,424.3492;Float;False;Property;_AO;AO;17;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;183;-703.0445,420.8408;Float;True;Property;_MetalTexture;MetalTexture;16;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;172;-348.8417,-56.33969;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;135;-368.8939,82.99744;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;182;-708.2452,230.1511;Float;True;Property;_Smootness;Smootness;15;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-324.1214,106.6757;Float;False;Property;_Wetness;Wetness;9;0;Create;True;0;0;False;0;0.8;1.49;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;-141.6498,180.468;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendNormalsNode;133;-295.8939,16.99744;Float;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;153;-145.4785,280.4446;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;85;-1003.842,-779.21;Float;False;Abedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;160;-125.812,388.4932;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;89;-219.8372,-61.30411;Float;False;85;Abedo;0;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;142.7537,-5.260873;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;RippleShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;14;0;3;0
WireConnection;125;0;16;0
WireConnection;119;0;125;0
WireConnection;56;0;55;0
WireConnection;56;1;58;0
WireConnection;61;0;59;0
WireConnection;61;1;60;0
WireConnection;72;0;74;0
WireConnection;72;1;73;0
WireConnection;124;0;119;0
WireConnection;53;0;56;0
WireConnection;53;1;61;0
WireConnection;70;0;72;0
WireConnection;70;1;61;0
WireConnection;120;0;124;0
WireConnection;48;0;53;0
WireConnection;71;0;70;0
WireConnection;75;0;48;0
WireConnection;75;1;71;0
WireConnection;121;0;120;0
WireConnection;5;0;7;0
WireConnection;41;0;121;0
WireConnection;27;0;8;0
WireConnection;113;0;5;0
WireConnection;77;0;78;0
WireConnection;77;1;75;0
WireConnection;62;0;77;0
WireConnection;19;0;41;0
WireConnection;19;1;42;0
WireConnection;118;0;16;0
WireConnection;26;0;27;0
WireConnection;114;0;113;0
WireConnection;67;0;64;0
WireConnection;115;0;114;0
WireConnection;117;0;118;0
WireConnection;52;0;5;0
WireConnection;21;0;19;1
WireConnection;20;0;19;2
WireConnection;28;0;26;0
WireConnection;2;0;117;0
WireConnection;22;0;21;0
WireConnection;22;1;20;0
WireConnection;29;0;28;0
WireConnection;51;0;52;0
WireConnection;65;0;67;0
WireConnection;116;0;115;0
WireConnection;122;0;65;0
WireConnection;50;0;51;0
WireConnection;24;0;8;0
WireConnection;68;0;64;0
WireConnection;12;0;2;2
WireConnection;10;0;2;1
WireConnection;18;13;22;0
WireConnection;18;2;116;0
WireConnection;45;0;29;0
WireConnection;11;0;10;0
WireConnection;11;1;12;0
WireConnection;23;0;24;0
WireConnection;49;0;50;0
WireConnection;66;0;68;0
WireConnection;17;0;45;0
WireConnection;17;1;18;0
WireConnection;17;5;122;0
WireConnection;123;0;66;0
WireConnection;38;0;17;0
WireConnection;25;0;23;0
WireConnection;1;13;11;0
WireConnection;1;2;49;0
WireConnection;4;0;25;0
WireConnection;4;1;1;0
WireConnection;4;5;123;0
WireConnection;39;0;38;0
WireConnection;181;0;4;0
WireConnection;104;0;39;0
WireConnection;33;0;181;0
WireConnection;33;1;104;0
WireConnection;179;0;33;0
WireConnection;146;0;145;0
WireConnection;180;0;179;0
WireConnection;147;0;146;0
WireConnection;184;1;148;0
WireConnection;177;0;180;0
WireConnection;188;0;184;0
WireConnection;173;0;177;0
WireConnection;173;1;177;1
WireConnection;189;0;188;0
WireConnection;126;1;148;0
WireConnection;176;0;173;0
WireConnection;176;1;174;0
WireConnection;186;0;189;0
WireConnection;169;0;126;0
WireConnection;80;1;147;0
WireConnection;175;0;176;0
WireConnection;175;2;177;2
WireConnection;187;0;186;0
WireConnection;83;0;80;0
WireConnection;83;1;82;0
WireConnection;168;0;169;0
WireConnection;178;0;175;0
WireConnection;158;5;168;0
WireConnection;185;0;187;0
WireConnection;34;0;178;0
WireConnection;84;0;83;0
WireConnection;84;1;81;0
WireConnection;137;0;35;0
WireConnection;162;0;185;0
WireConnection;162;1;84;0
WireConnection;170;0;158;0
WireConnection;161;1;84;0
WireConnection;161;0;162;0
WireConnection;183;1;148;0
WireConnection;172;0;170;0
WireConnection;135;0;137;0
WireConnection;182;1;148;0
WireConnection;150;0;9;0
WireConnection;150;1;182;0
WireConnection;133;0;172;0
WireConnection;133;1;135;0
WireConnection;153;0;183;0
WireConnection;153;1;152;0
WireConnection;85;0;161;0
WireConnection;160;0;184;0
WireConnection;160;1;159;0
WireConnection;0;0;89;0
WireConnection;0;1;133;0
WireConnection;0;3;153;0
WireConnection;0;4;150;0
WireConnection;0;5;160;0
ASEEND*/
//CHKSM=C584C3823FEC45167073E73E73E0D74C236185E2