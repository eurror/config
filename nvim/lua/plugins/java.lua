return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jdtls = {
          settings = {
            java = {

              -- Code lens
              implementationCodeLens = {
                enabled = true,
              },
              referencesCodeLens = {
                enabled = true,
              },

              -- Inlay hints
              inlayHints = {
                parameterNames = {
                  enabled = "all",
                },
                parameterTypes = {
                  enabled = true,
                },
                variableTypes = {
                  enabled = true,
                },
              },

              -- Formatting
              format = {
                enabled = true,
                settings = {
                  profile = "GoogleStyle",
                },
              },

              -- Code generation preferences
              codeGeneration = {
                hashCodeEquals = {
                  useJava7Objects = true,
                },
                useBlocks = true,
                toString = {
                  template = "${object.className} [${member.name()}=${member.value}, ${otherMembers}]",
                },
              },

              -- Automatic build configuration updates
              configuration = {
                updateBuildConfiguration = "automatic",
              },

              -- Null analysis
              compile = {
                nullAnalysis = {
                  mode = "automatic",
                },
              },
              maxConcurrentBuilds = 2,

              -- Dependency presentation
              dependency = {
                packagePresentation = "hierarchical",
              },

              -- Download sources for better code navigation
              eclipse = {
                downloadSources = true,
              },
              maven = {
                downloadSources = true,
              },

              -- Include source method declarations in symbols
              symbols = {
                includeSourceMethodDeclarations = true,
              },
            },
          },
        },
      },
    },
  },

  -- Treesitter for Java
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "java",
      },
    },
  },
}
