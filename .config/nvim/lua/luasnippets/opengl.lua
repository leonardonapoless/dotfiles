local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local function filename()
    return vim.fn.expand('%:t:r')
end

return {
    -- OpenGL GLFW bootstrap with error handling
    s({ trig = "gl_bootstrap", name = "OpenGL Bootstrap", dscr = "GLFW window setup", priority = 1000 }, fmt([[
        #include <stdio.h>
        #include <stdlib.h>
        #define GL_SILENCE_DEPRECATION
        #include <GLFW/glfw3.h>

        void error_callback(int error, const char* description) {{
            fprintf(stderr, "GLFW Error %d: %s\n", error, description);
        }}

        int main(void) {{
            glfwSetErrorCallback(error_callback);

            if (!glfwInit()) {{
                fprintf(stderr, "Failed to initialize GLFW\n");
                return -1;
            }}

            glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, {});
            glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, {});
            glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
            glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);

            GLFWwindow* window = glfwCreateWindow({}, {}, "{}", NULL, NULL);
            if (!window) {{
                fprintf(stderr, "Failed to create window\n");
                glfwTerminate();
                return -1;
            }}

            glfwMakeContextCurrent(window);
            glfwSwapInterval(1);

            while (!glfwWindowShouldClose(window)) {{
                int width, height;
                glfwGetFramebufferSize(window, &width, &height);
                glViewport(0, 0, width, height);

                glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

                {}

                glfwSwapBuffers(window);
                glfwPollEvents();
            }}

            glfwDestroyWindow(window);
            glfwTerminate();
            return 0;
        }}
    ]], {
        c(1, { t("4"), t("3") }),
        c(2, { t("1"), t("3") }),
        i(3, "800"),
        i(4, "600"),
        i(5, "OpenGL Window"),
        i(0, "// Render here")
    })),

    -- VAO/VBO with interleaved data
    s({ trig = "gl_vao", name = "VAO Setup", dscr = "Vertex Array Object loop" }, fmt([[
        GLuint VAO, VBO;
        glGenVertexArrays(1, &VAO);
        glGenBuffers(1, &VBO);

        glBindVertexArray(VAO);
        glBindBuffer(GL_ARRAY_BUFFER, VBO);
        glBufferData(GL_ARRAY_BUFFER, sizeof({}), {}, GL_STATIC_DRAW);

        // Position attribute
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, {} * sizeof(float), (void*)0);
        glEnableVertexAttribArray(0);

        {}

        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindVertexArray(0);
    ]], {
        i(1, "vertices"),
        rep(1),
        i(2, "8"),
        i(0, "// Additional attributes")
    })),

    -- Complete shader program with error checking
    s({ trig = "gl_shader", name = "Shader Program", dscr = "Compile & Link Shaders", priority = 900 }, fmt([[
        const char* {}VertexShaderSource = R"(
            #version {} core
            layout (location = 0) in vec3 aPos;
            {}
            void main() {{
                gl_Position = vec4(aPos, 1.0);
                {}
            }}
        )";

        const char* {}FragmentShaderSource = R"(
            #version {} core
            out vec4 FragColor;
            {}
            void main() {{
                FragColor = vec4({});
            }}
        )";

        // Compile vertex shader
        GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
        glShaderSource(vertexShader, 1, &{}VertexShaderSource, NULL);
        glCompileShader(vertexShader);

        // Check compilation
        int success;
        char infoLog[512];
        glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &success);
        if (!success) {{
            glGetShaderInfoLog(vertexShader, 512, NULL, infoLog);
            fprintf(stderr, "Vertex shader compilation failed: %s\n", infoLog);
        }}

        // Compile fragment shader
        GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
        glShaderSource(fragmentShader, 1, &{}FragmentShaderSource, NULL);
        glCompileShader(fragmentShader);

        glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &success);
        if (!success) {{
            glGetShaderInfoLog(fragmentShader, 512, NULL, infoLog);
            fprintf(stderr, "Fragment shader compilation failed: %s\n", infoLog);
        }}

        // Link program
        GLuint shaderProgram = glCreateProgram();
        glAttachShader(shaderProgram, vertexShader);
        glAttachShader(shaderProgram, fragmentShader);
        glLinkProgram(shaderProgram);

        glGetProgramiv(shaderProgram, GL_LINK_STATUS, &success);
        if (!success) {{
            glGetProgramInfoLog(shaderProgram, 512, NULL, infoLog);
            fprintf(stderr, "Shader program linking failed: %s\n", infoLog);
        }}

        glDeleteShader(vertexShader);
        glDeleteShader(fragmentShader);
    ]], {
        i(1, "basic"),
        c(2, { t("410"), t("330"), t("150") }),
        i(3, "// Vertex shader inputs"),
        i(4, "// Vertex shader logic"),
        rep(1),
        rep(2),
        i(5, "// Fragment shader inputs"),
        i(6, "1.0, 0.5, 0.2, 1.0"),
        rep(1),
        rep(1)
    })),

    -- Texture loading with stb_image
    s({ trig = "gl_texture", name = "Texture Load", dscr = "Load texture (stb_image)" }, fmt([[
        #define STB_IMAGE_IMPLEMENTATION
        #include "stb_image.h"

        GLuint {};
        glGenTextures(1, &{});
        glBindTexture(GL_TEXTURE_2D, {});

        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, {});
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, {});
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

        int width, height, nrChannels;
        stbi_set_flip_vertically_on_load(true);
        unsigned char* data = stbi_load("{}", &width, &height, &nrChannels, 0);

        if (data) {{
            GLenum format = (nrChannels == 4) ? GL_RGBA : GL_RGB;
            glTexImage2D(GL_TEXTURE_2D, 0, format, width, height, 0, format, GL_UNSIGNED_BYTE, data);
            glGenerateMipmap(GL_TEXTURE_2D);
        }} else {{
            fprintf(stderr, "Failed to load texture: %s\n", "{}");
        }}

        stbi_image_free(data);
        glBindTexture(GL_TEXTURE_2D, 0);
    ]], {
        i(1, "texture"),
        rep(1),
        rep(1),
        c(2, { t("GL_REPEAT"), t("GL_CLAMP_TO_EDGE"), t("GL_MIRRORED_REPEAT") }),
        rep(2),
        i(3, "texture.png"),
        rep(3)
    })),

    -- Framebuffer for offscreen rendering
    s({ trig = "gl_fbo", name = "Framebuffer", dscr = "Offscreen FBO setup" }, fmt([[
        GLuint fbo;
        glGenFramebuffers(1, &fbo);
        glBindFramebuffer(GL_FRAMEBUFFER, fbo);

        // Create color texture
        GLuint textureColorbuffer;
        glGenTextures(1, &textureColorbuffer);
        glBindTexture(GL_TEXTURE_2D, textureColorbuffer);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, {}, {}, 0, GL_RGB, GL_UNSIGNED_BYTE, NULL);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, textureColorbuffer, 0);

        // Create depth/stencil renderbuffer
        GLuint rbo;
        glGenRenderbuffers(1, &rbo);
        glBindRenderbuffer(GL_RENDERBUFFER, rbo);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH24_STENCIL8, {}, {});
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_STENCIL_ATTACHMENT, GL_RENDERBUFFER, rbo);

        if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
            fprintf(stderr, "ERROR: Framebuffer is not complete!\n");

        glBindFramebuffer(GL_FRAMEBUFFER, 0);
    ]], {
        i(1, "800"),
        i(2, "600"),
        rep(1),
        rep(2)
    })),

    -- MVP matrices with GLM
    s({ trig = "gl_mvp", name = "MVP Matrix", dscr = "Model-View-Projection (GLM)" }, fmt([[
        #include <glm/glm.hpp>
        #include <glm/gtc/matrix_transform.hpp>
        #include <glm/gtc/type_ptr.hpp>

        // Model matrix
        glm::mat4 model = glm::mat4(1.0f);
        model = glm::translate(model, glm::vec3({}, {}, {}));
        model = glm::rotate(model, glm::radians({}), glm::vec3({}, {}, {}));

        // View matrix (camera)
        glm::mat4 view = glm::lookAt(
            glm::vec3({}, {}, {}),  // Camera position
            glm::vec3({}, {}, {}),  // Look at target
            glm::vec3(0.0f, 1.0f, 0.0f)   // Up vector
        );

        // Projection matrix
        glm::mat4 projection = glm::perspective(
            glm::radians({}),     // FOV
            {}f / {}f,      // Aspect ratio
            {}f,             // Near plane
            {}f              // Far plane
        );

        // Send to shader
        GLint modelLoc = glGetUniformLocation(shaderProgram, "model");
        GLint viewLoc = glGetUniformLocation(shaderProgram, "view");
        GLint projectionLoc = glGetUniformLocation(shaderProgram, "projection");

        glUniformMatrix4fv(modelLoc, 1, GL_FALSE, glm::value_ptr(model));
        glUniformMatrix4fv(viewLoc, 1, GL_FALSE, glm::value_ptr(view));
        glUniformMatrix4fv(projectionLoc, 1, GL_FALSE, glm::value_ptr(projection));
    ]], {
        i(1, "0.0f"), i(2, "0.0f"), i(3, "0.0f"),
        i(4, "45.0f"),
        i(5, "0.0f"), i(6, "1.0f"), i(7, "0.0f"),
        i(8, "0.0f"), i(9, "0.0f"), i(10, "3.0f"),
        i(11, "0.0f"), i(12, "0.0f"), i(13, "0.0f"),
        i(14, "45.0f"),
        i(15, "800.0"), i(16, "600.0"),
        i(17, "0.1"), i(18, "100.0")
    })),

    -- GLSL vertex shader
    s({ trig = "glsl_vertex", name = "GLSL Vertex", dscr = "Vertex Shader structure", priority = 900 }, fmt([[
        #version {} core

        layout (location = 0) in vec3 aPos;
        layout (location = 1) in vec3 aNormal;
        layout (location = 2) in vec2 aTexCoord;

        out vec3 FragPos;
        out vec3 Normal;
        out vec2 TexCoord;

        uniform mat4 model;
        uniform mat4 view;
        uniform mat4 projection;

        void main() {{
            FragPos = vec3(model * vec4(aPos, 1.0));
            Normal = mat3(transpose(inverse(model))) * aNormal;
            TexCoord = aTexCoord;

            gl_Position = projection * view * vec4(FragPos, 1.0);
        }}
    ]], {
        c(1, { t("410"), t("330"), t("150") })
    })),

    -- GLSL fragment shader with lighting
    s({ trig = "glsl_fragment", name = "GLSL Fragment", dscr = "Fragment Shader structure", priority = 900 }, fmt([[
        #version {} core

        in vec3 FragPos;
        in vec3 Normal;
        in vec2 TexCoord;

        out vec4 FragColor;

        uniform vec3 lightPos;
        uniform vec3 viewPos;
        uniform sampler2D texture1;

        void main() {{
            // Ambient
            float ambientStrength = 0.1;
            vec3 ambient = ambientStrength * vec3(1.0);

            // Diffuse
            vec3 norm = normalize(Normal);
            vec3 lightDir = normalize(lightPos - FragPos);
            float diff = max(dot(norm, lightDir), 0.0);
            vec3 diffuse = diff * vec3(1.0);

            // Specular
            float specularStrength = 0.5;
            vec3 viewDir = normalize(viewPos - FragPos);
            vec3 reflectDir = reflect(-lightDir, norm);
            float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32);
            vec3 specular = specularStrength * spec * vec3(1.0);

            vec3 result = (ambient + diffuse + specular) * texture(texture1, TexCoord).rgb;
            FragColor = vec4(result, 1.0);
        }}
    ]], {
        c(1, { t("410"), t("330"), t("150") })
    })),
}
