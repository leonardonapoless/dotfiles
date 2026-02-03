local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local rep = require("luasnip.extras").rep

local function filename()
    return vim.fn.expand('%:t:r')
end

return {
    -- Metal bootstrap with MTKView
    s({ trig = "mtl_bootstrap", name = "Metal Bootstrap", dscr = "Standard MTKView setup", priority = 1000 }, {
        t({ "#import <Metal/Metal.h>", "#import <MetalKit/MetalKit.h>", "#import <Cocoa/Cocoa.h>", "", "@interface " }),
        i(1, "MetalRenderer"),
        t({ " : NSObject <MTKViewDelegate>", "@property (nonatomic, strong) id<MTLDevice> device;",
            "@property (nonatomic, strong) id<MTLCommandQueue> commandQueue;", "@end", "", "@implementation " }),
        rep(1),
        t({ "", "", "- (instancetype)initWithMTKView:(MTKView *)mtkView {", "    self = [super init];", "    if (self) {",
            "        self.device = mtkView.device;", "        self.commandQueue = [self.device newCommandQueue];",
            "    }", "    return self;", "}", "", "- (void)drawInMTKView:(MTKView *)view {",
            "    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];",
            "    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;", "",
            "    if (renderPassDescriptor != nil) {", "        id<MTLRenderCommandEncoder> renderEncoder =",
            "            [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];", "", "        " }),
        i(2, "// Rendering code"),
        t({ "", "", "        [renderEncoder endEncoding];",
            "        [commandBuffer presentDrawable:view.currentDrawable];", "    }", "", "    [commandBuffer commit];",
            "}", "", "- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {", "    " }),
        i(3, "// Handle resize"),
        t({ "", "}", "", "@end" }),
    }),

    -- Metal render pipeline
    s({ trig = "mtl_pipeline", name = "Render Pipeline", dscr = "Render pipeline setup" }, {
        t({ "id<MTLLibrary> library = [self.device newDefaultLibrary];",
            "id<MTLFunction> vertexFunction = [library newFunctionWithName:@\"" }),
        i(1, "vertexShader"),
        t({ "\"];", "id<MTLFunction> fragmentFunction = [library newFunctionWithName:@\"" }),
        i(2, "fragmentShader"),
        t({ "\"];", "", "MTLRenderPipelineDescriptor *pipelineDescriptor = [[MTLRenderPipelineDescriptor alloc] init];",
            "pipelineDescriptor.vertexFunction = vertexFunction;",
            "pipelineDescriptor.fragmentFunction = fragmentFunction;",
            "pipelineDescriptor.colorAttachments[0].pixelFormat = " }),
        c(3, { t("MTLPixelFormatBGRA8Unorm"), t("MTLPixelFormatRGBA8Unorm"), t("MTLPixelFormatRGBA16Float") }),
        t({ ";", "" }),
        i(0, "// Additional configuration"),
        t({ "", "", "NSError *error = nil;", "id<MTLRenderPipelineState> pipelineState =",
            "    [self.device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];", "",
            "if (!pipelineState) {", "    NSLog(@\"Failed to create pipeline: %@\", error);", "}" }),
    }),

    -- MSL vertex shader
    s({ trig = "msl_vertex", name = "MSL Vertex", dscr = "Metal Shading Language Vertex Shader", priority = 900 }, {
        t({ "#include <metal_stdlib>", "using namespace metal;", "", "struct VertexIn {",
            "    float3 position [[attribute(0)]];", "    " }),
        i(1, "float4 color [[attribute(1)]];"),
        t({ "", "};", "", "struct VertexOut {", "    float4 position [[position]];", "    " }),
        i(2, "float4 color;"),
        t({ "", "};", "", "vertex VertexOut " }),
        i(3, "vertexShader"),
        t({ "(VertexIn in [[stage_in]]) {", "    VertexOut out;", "    out.position = float4(in.position, 1.0);", "    " }),
        i(0, "out.color = in.color;"),
        t({ "", "    return out;", "}" }),
    }),

    -- MSL fragment shader
    s({ trig = "msl_fragment", name = "MSL Fragment", dscr = "Metal Shading Language Fragment Shader", priority = 900 },
        {
            t({ "#include <metal_stdlib>", "using namespace metal;", "", "fragment float4 " }),
            i(1, "fragmentShader"),
            t({ "(float4 color [[stage_in]]) {", "    " }),
            i(0, "return color;"),
            t({ "", "}" }),
        }),

    -- MSL compute kernel
    s({ trig = "msl_compute", name = "MSL Compute", dscr = "Metal Shading Language Compute Kernel", priority = 900 }, {
        t({ "#include <metal_stdlib>", "using namespace metal;", "", "kernel void " }),
        i(1, "computeKernel"),
        t({ "(device float* input [[buffer(0)]],", " device float* output [[buffer(1)]],",
            " uint id [[thread_position_in_grid]]) {", "    " }),
        i(0, "output[id] = input[id] * 2.0f;"),
        t({ "", "}" }),
    }),

    -- Metal texture
    s({ trig = "mtl_texture", name = "Metal Texture", dscr = "Texture descriptor setup" }, {
        t({ "MTLTextureDescriptor *textureDescriptor = [[MTLTextureDescriptor alloc] init];",
            "textureDescriptor.pixelFormat = " }),
        c(1, { t("MTLPixelFormatRGBA8Unorm"), t("MTLPixelFormatBGRA8Unorm") }),
        t({ ";", "textureDescriptor.width = " }),
        i(2, "1024"),
        t({ ";", "textureDescriptor.height = " }),
        i(3, "1024"),
        t({ ";", "textureDescriptor.usage = MTLTextureUsageShaderRead;", "",
            "id<MTLTexture> texture = [self.device newTextureWithDescriptor:textureDescriptor];" }),
    }),

    -- Metal vertex buffer (Objective-C)
    s({ trig = "mtl_vertex", name = "Vertex Buffer", dscr = "Vertex buffer with struct" }, {
        t({ "typedef struct {", "    vector_float3 position;", "    vector_float4 color;", "} " }),
        i(1, "Vertex"),
        t({ ";", "", "static const " }),
        rep(1),
        t({ " vertices[] = {", "    { { " }),
        i(2, "0.0f, 0.5f, 0.0f"),
        t({ " }, { " }),
        i(3, "1.0f, 0.0f, 0.0f, 1.0f"),
        t({ " } },", "    " }),
        i(0, "// More vertices"),
        t({ "", "};", "", "id<MTLBuffer> vertexBuffer = [self.device newBufferWithBytes:vertices",
            "                                                      length:sizeof(vertices)",
            "                                                     options:MTLResourceStorageModeShared];" }),
    }),

    -- Metal depth/stencil state
    s({ trig = "mtl_depth", name = "Depth Stencil", dscr = "Depth stencil descriptor" }, {
        t({ "MTLDepthStencilDescriptor *depthDescriptor = [[MTLDepthStencilDescriptor alloc] init];",
            "depthDescriptor.depthCompareFunction = " }),
        c(1, { t("MTLCompareFunctionLess"), t("MTLCompareFunctionLessEqual"), t("MTLCompareFunctionGreater") }),
        t({ ";", "depthDescriptor.depthWriteEnabled = " }),
        c(2, { t("YES"), t("NO") }),
        t({ ";", "",
            "id<MTLDepthStencilState> depthState = [self.device newDepthStencilStateWithDescriptor:depthDescriptor];",
            "    [renderEncoder setDepthStencilState:depthState];" }),
    }),

    -- Metal MSAA
    s({ trig = "mtl_msaa", name = "MSAA Setup", dscr = "Multisample Anti-Aliasing" }, {
        t({ "pipelineDescriptor.sampleCount = " }),
        c(1, { t("4"), t("2"), t("8") }),
        t({ ";", "",
            "MTLTextureDescriptor *msaaDescriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatBGRA8Unorm",
            "                                                                                       width:" }),
        i(2, "width"),
        t({ "", "                                                                                      height:" }),
        i(3, "height"),
        t({ "", "                                                                                   mipmapped:NO];",
            "msaaDescriptor.textureType = MTLTextureType2DMultisample;", "msaaDescriptor.sampleCount = " }),
        rep(1),
        t({ ";", "msaaDescriptor.usage = MTLTextureUsageRenderTarget;", "",
            "id<MTLTexture> msaaTexture = [self.device newTextureWithDescriptor:msaaDescriptor];" }),
    }),

    -- Metal compute pipeline
    s({ trig = "mtl_compute_pipeline", name = "Compute Pipeline", dscr = "Compute pipeline setup" }, {
        t({ "id<MTLLibrary> library = [self.device newDefaultLibrary];",
            "id<MTLFunction> computeFunction = [library newFunctionWithName:@\"" }),
        i(1, "computeKernel"),
        t({ "\"];", "", "NSError *error = nil;", "id<MTLComputePipelineState> computePipelineState =",
            "    [self.device newComputePipelineStateWithFunction:computeFunction error:&error];", "",
            "id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];",
            "id<MTLComputeCommandEncoder> computeEncoder = [commandBuffer computeCommandEncoder];", "",
            "[computeEncoder setComputePipelineState:computePipelineState];", "[computeEncoder setBuffer:" }),
        i(2, "inputBuffer"),
        t({ " offset:0 atIndex:0];", "[computeEncoder setBuffer:" }),
        i(3, "outputBuffer"),
        t({ " offset:0 atIndex:1];", "", "MTLSize threadGroupSize = MTLSizeMake(256, 1, 1);",
            "MTLSize threadGroups = MTLSizeMake(dataSize / 256, 1, 1);",
            "[computeEncoder dispatchThreadgroups:threadGroups threadsPerThreadgroup:threadGroupSize];", "",
            "[computeEncoder endEncoding];", "[commandBuffer commit];" }),
    }),
}
