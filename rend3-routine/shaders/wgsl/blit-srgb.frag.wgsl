[[group(1), binding(0)]]
var source: texture_2d<f32>;
[[group(0), binding(0)]]
var primary_sampler: sampler;
var<private> tex_coords_1: vec2<f32>;
var<private> color: vec4<f32>;

fn main_1() {
    let _e34 = tex_coords_1;
    let _e35 = textureSample(source, primary_sampler, _e34);
    let _e37 = (_e35.xyz * 2.0);
    let _e38 = (_e37 * 0.15000000596046448);
    let _e47 = (((((_e37 * (_e38 + vec3<f32>(0.05000000074505806, 0.05000000074505806, 0.05000000074505806))) + vec3<f32>(0.004000000189989805, 0.004000000189989805, 0.004000000189989805)) / ((_e37 * (_e38 + vec3<f32>(0.5, 0.5, 0.5))) + vec3<f32>(0.06000000238418579, 0.06000000238418579, 0.06000000238418579))) - vec3<f32>(0.06666666269302368, 0.06666666269302368, 0.06666666269302368)) * vec3<f32>(1.3790643215179443, 1.3790643215179443, 1.3790643215179443));
    let _e53 = vec4<f32>(_e47.x, _e47.y, _e47.z, _e35.w).xyz;
    let _e61 = mix((_e53 * 12.920000076293945), ((pow(_e53, vec3<f32>(0.41666001081466675, 0.41666001081466675, 0.41666001081466675)) * 1.0549999475479126) - vec3<f32>(0.054999999701976776, 0.054999999701976776, 0.054999999701976776)), clamp(ceil((_e53 - vec3<f32>(0.0031308000907301903, 0.0031308000907301903, 0.0031308000907301903))), vec3<f32>(0.0, 0.0, 0.0), vec3<f32>(1.0, 1.0, 1.0)));
    color = vec4<f32>(_e61.x, _e61.y, _e61.z, _e35.w);
    return;
}

[[stage(fragment)]]
fn main([[location(0)]] tex_coords: vec2<f32>) -> [[location(0)]] vec4<f32> {
    tex_coords_1 = tex_coords;
    main_1();
    let _e3 = color;
    return _e3;
}
