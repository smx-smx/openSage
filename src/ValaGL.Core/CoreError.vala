/*
    CoreError.vala
    Copyright (C) 2013 Maia Kozheva <sikon@ubuntu.com>

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
*/

namespace ValaGL.Core {

/**
 * Error domain for the ValaGL core OpenGL support.
 */
public errordomain CoreError {
	/**
	 * Indicates a vertex or fragment shader initialization error.
	 */
    SHADER_INIT,
    /**
     * Indicates a texture initialization error.
     */
    TEXTURE_INIT,
    /**
     * Indicates a vertex array object initialization error.
     */
    VAO_INIT,
	/**
	 * Indicates a vertex buffer object initialization error.
	 */
	VBO_INIT,
	/**
	 * Indicates an index buffer object initialization error.
	 */
    IBO_INIT,
    /**
	 * Indicates a frame buffer object initialization error.
	 */
    FBO_INIT
}

}
