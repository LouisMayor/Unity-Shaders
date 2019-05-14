using System;
using UnityEngine;

public class NormalPP : PostProcess
{
    [SerializeField] private bool m_viewSpaceNormals = false;
    [SerializeField] private Camera m_camera;

    private void Awake()
    {
        m_sourceMaterial = new Material(Shader.Find("Unlit/NormalVisual"));

        if (m_sourceMaterial.shader == null)
        {
            Debug.LogError("Failed to find shader");
        }

        m_camera = GetComponent<Camera>();

        if(m_camera == null)
        {
            Debug.LogError("Failed to find a camera");
        }
    }

    protected override void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        base.OnRenderImage(source, destination);

        m_sourceMaterial.SetInt("_ViewSpaceNormals", Convert.ToInt32(m_viewSpaceNormals));
        m_sourceMaterial.SetMatrix("_WorldMatrix", m_camera.cameraToWorldMatrix);

        Graphics.Blit(source, destination, m_sourceMaterial);

    }
}
