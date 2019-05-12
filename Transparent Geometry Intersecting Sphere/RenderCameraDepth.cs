using UnityEngine;

[ExecuteInEditMode]
public class RenderCameraDepth : MonoBehaviour
{
    void OnEnable()
    {
        Camera renderer = GetComponent<Camera>();
        if (renderer == null)
        {
            Debug.LogError("Failed to find camera");
            return;
        }

        renderer.depthTextureMode = DepthTextureMode.DepthNormals;
    }
}
