using UnityEngine;

[ExecuteInEditMode]
public class PostProcess : MonoBehaviour
{
    [SerializeField] protected Material m_sourceMaterial;
    public bool Enable = true;

    protected virtual void OnRenderImage(RenderTexture source, RenderTexture destination)
    {}
}
