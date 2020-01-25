AGSScriptModule    Ivan Mogilko Module performs rendering of TypedText state to the provided DrawingSurface TypedTextDrawing 0.7.0 �4  //===========================================================================
//
// TypedTextDrawing::PrecalcText
//
//===========================================================================
#define LINE_BREAK '['
void PrecalcText(this TypedTextDrawing*)
{
  if (String.IsNullOrEmpty(this._full))
    return;
    
  //Display("TypedTextDrawing::PrecalcText, size = %d x %d", this._width, this._height);

  this._lineCount = 0;
  // First we make sure text is split to fit into bounding rectangle.
  this._full = TypedTextUtils.SplitText(this._full, this._width, this._font, this._height,
                                        this._fontHeight + this._lineSpacing, this._maxVisLines);
  // Next, we parse the resulting string once again to find number of lines
  // and where they end.
  int i = 0;
  int line_start = 0;
  int line_end = 0;
  int line_count = 0;
  this._lineBeginsAt[0] = 0;
  while (i <= this._full.Length && line_count < TYPEDTEXTDRAWING_MAXLINES)
  {
    if (i == this._full.Length || this._full.Chars[i] == LINE_BREAK)
    {
      line_end = i;
      this._lineEndsAt[line_count] = line_end;
      if (line_end > line_start && this._textAlign != eAlignLeft)
      {
        String s = this._full.Substring(line_start, line_end - line_start);
        //Display(">>> '%s'",s);
        int linewidth = GetTextWidth(s, this._font);
        if (this._textAlign == eAlignCentre)
          this._lineX[line_count] = (this._width - linewidth) / 2;
        else
          this._lineX[line_count] = this._width - linewidth;
        //Display("lineX = %d, linewidth = %d, ends at px = %d", this._lineX[line_count], linewidth, this._lineX[line_count] + this._x + linewidth - 1);
      }
      else
      {
        this._lineX[line_count] = 0;
      }
      
      line_start = line_end + 1;
      line_count++;
      if (line_count < TYPEDTEXTDRAWING_MAXLINES)
        this._lineBeginsAt[line_count] = line_start;
    }
    i++;
  }
  
  if (line_count < TYPEDTEXTDRAWING_MAXLINES)
    this._lineCount = line_count;
  else
    this._lineCount = line_count - 1;
}

//===========================================================================
//
// TypedTextDrawing::RecalcDisplay
//
// Calculates derived alignment parameters using current configuration.
//
//===========================================================================
void RecalcDisplay(this TypedTextDrawing*)
{
  int text_height = TypedTextUtils.GetFontHeight(this._font);
  if (this._caretSprite > 0 && text_height < Game.SpriteHeight[this._caretSprite])
    this._fontHeight = Game.SpriteHeight[this._caretSprite];
  else
    this._fontHeight = text_height;
  
  if (this._fontHeight > 0 || this._lineSpacing > 0)
    this._maxVisLines = this._height / (this._fontHeight + this._lineSpacing);
  else
    this._maxVisLines = 0;
  this._maxVisLines = this._maxVisLines;
  if (this._maxVisLines > TYPEDTEXTDRAWING_MAXLINES)
    this._maxVisLines = TYPEDTEXTDRAWING_MAXLINES;

  if (this._textAlign == eAlignCentre)
    this._lineXDefault = this._width / 2;
  else if (this._textAlign == eAlignRight)
    this._lineXDefault = this._width - 1;
  else
    this._lineXDefault = 0;
  
  this.PrecalcText();
  this._hasChanged = true;
}

//===========================================================================
//
// TypedTextDrawing::SetDrawingRect()
//
//===========================================================================
void TypedTextDrawing::SetDrawingRect(int x, int y, int width, int height)
{
  this._x = x;
  this._y = y;
  this._width = width;
  this._height = height;
  this.RecalcDisplay();
}

//===========================================================================
//
// TypedTextDrawing::SetTextParams()
//
//===========================================================================
void TypedTextDrawing::SetDrawingParams(FontType font, int color, int bkg_color, Alignment align, int line_spacing)
{
  this._font = font;
  this._textColor = color;
  this._bkgColor = bkg_color;
  this._textAlign = align;
  this._lineSpacing = line_spacing;
  this.RecalcDisplay();
}

//===========================================================================
//
// TypedTextDrawing::X property
//
//===========================================================================
int get_X(this TypedTextDrawing*)
{
  return this._x;
}

void set_X(this TypedTextDrawing*, int value)
{
  this._x = value;
  this._hasChanged = true;
}

//===========================================================================
//
// TypedTextDrawing::Y property
//
//===========================================================================
int get_Y(this TypedTextDrawing*)
{
  return this._y;
}

void set_Y(this TypedTextDrawing*, int value)
{
  this._y = value;
  this._hasChanged = true;
}

//===========================================================================
//
// TypedTextDrawing::Width property
//
//===========================================================================
int get_Width(this TypedTextDrawing*)
{
  return this._width;
}

void set_Width(this TypedTextDrawing*, int value)
{
  this._width = value;
  this.RecalcDisplay();
}

//===========================================================================
//
// TypedTextDrawing::Height property
//
//===========================================================================
int get_Height(this TypedTextDrawing*)
{
  return this._height;
}

void set_Height(this TypedTextDrawing*, int value)
{
  this._height = value;
  this.RecalcDisplay();
}

//===========================================================================
//
// TypedTextDrawing::Font property
//
//===========================================================================
FontType get_Font(this TypedTextDrawing*)
{
  return this._font;
}

void set_Font(this TypedTextDrawing*, FontType value)
{
  this._font = value;
  this.RecalcDisplay();
}

//===========================================================================
//
// TypedTextDrawing::LineHeight property
//
//===========================================================================
int get_LineHeight(this TypedTextDrawing*)
{
  return this._fontHeight;
}

//===========================================================================
//
// TypedTextDrawing::LineSpacing property
//
//===========================================================================
int get_LineSpacing(this TypedTextDrawing*)
{
  return this._lineSpacing;
}

void set_LineSpacing(this TypedTextDrawing*, int value)
{
  this._lineSpacing = value;
  this.RecalcDisplay();
}

//===========================================================================
//
// TypedTextDrawing::TextAlign property
//
//===========================================================================
Alignment get_TextAlign(this TypedTextDrawing*)
{
  return this._textAlign;
}

void set_TextAlign(this TypedTextDrawing*, Alignment value)
{
  this._textAlign = value;
  this.RecalcDisplay();
}

//===========================================================================
//
// TypedTextDrawing::TextColor property
//
//===========================================================================
int get_TextColor(this TypedTextDrawing*)
{
  return this._textColor;
}

void set_TextColor(this TypedTextDrawing*, int value)
{
  this._textColor = value;
  this._hasChanged = true;
}

//===========================================================================
//
// TypedTextDrawing::BkgColor property
//
//===========================================================================
int get_BkgColor(this TypedTextDrawing*)
{
  return this._bkgColor;
}

void set_BkgColor(this TypedTextDrawing*, int value)
{
  this._bkgColor = value;
  this._hasChanged = true;
}

//===========================================================================
//
// TypedTextDrawing::CaretSprite property
//
//===========================================================================
int get_CaretSprite(this TypedTextDrawing*)
{
  return this._caretSprite;
}

void set_CaretSprite(this TypedTextDrawing*, int value)
{
  this._caretSprite = value;
  this._hasChanged = true;
}

//===========================================================================
//
// TypedTextDrawing::Clear
//
//===========================================================================
void TypedTextDrawing::Clear()
{
  this._RenderClear();
  this._lineCount = 0;
}

//===========================================================================
//
// TypedTextDrawing::Start
//
//===========================================================================
void TypedTextDrawing::Start(String text)
{
  this._RenderStart(text);
  this.PrecalcText();
}

//===========================================================================
//
// TypedTextDrawing::Tick
//
//===========================================================================
void TypedTextDrawing::Tick()
{
  this._RenderTick();
}

//===========================================================================
//
// TypedTextDrawing::DrawRect
//
// Draws bounding rect.
//
//===========================================================================
void DrawRect(this TypedTextDrawing*, DrawingSurface *ds)
{
  ds.DrawingColor = this._bkgColor;
  ds.DrawRectangle(this._x, this._y, this._x + this._width - 1, this._y + this._height - 1);
}

//===========================================================================
//
// TypedTextDrawing::DrawExplicitCaret
//
// Draws explicit caret string or sprite.
//
//===========================================================================
void DrawExplicitCaret(this TypedTextDrawing*, DrawingSurface *ds, int x, int y, Alignment align)
{
  int caret_x;
  int caret_y;
  int caret_w;
  int caret_h;

  if (this._caretSprite > 0)
  {
    caret_w = Game.SpriteWidth[this._caretSprite];
    caret_h = Game.SpriteHeight[this._caretSprite];
  }
  else if (!String.IsNullOrEmpty(this._caretStr))
  {
    caret_w = GetTextWidth(this._caretStr, this._font);
    caret_h = this._fontHeight;
  }
  
  caret_y = y;
  if (align == eAlignCentre)
    caret_x = x - caret_w / 2;
  else if (align == eAlignRight)
    caret_x = x - caret_w;
  else
    caret_x = x;
  
  if (caret_x + caret_w <= this._x + this._width &&
      caret_y + caret_h <= this._y + this._height)
  {
    if (this._caretSprite > 0)
      ds.DrawImage(caret_x, caret_y, this._caretSprite);
    else
      ds.DrawString(caret_x, caret_y, this._font, "%s", this._caretStr);
  }
}

//===========================================================================
//
// TypedTextDrawing::DrawText
//
// Draws text lines.
//
//===========================================================================
void DrawText(this TypedTextDrawing*, DrawingSurface *ds)
{
  if (this._lineCount == 0)
    return;

  //
  // Draw text lines
  //
  int line_iterator = 0;
  int draw_end = this._cur.Length;
  int y = this._y;
  int line_height = this._lineSpacing + this._fontHeight;
  int line_end = 0;
  String line_str;
  
  // If the caret is depicted with the flashing last character, then simply
  // do not draw that character when it is not supposed to be shown
  if (this._caretStyle == eTypedCaret_LastChar && !this.IsCaretShown)
    draw_end--;
  
  ds.DrawingColor = this._textColor;
  while (line_iterator < this._lineCount && line_end < draw_end)
  {
    int line_begin = this._lineBeginsAt[line_iterator];
    if (this._lineEndsAt[line_iterator] >= draw_end)
      line_end = draw_end;
    else
      line_end = this._lineEndsAt[line_iterator];

    if (line_end > line_begin)
      line_str = this._full.Substring(line_begin, line_end - line_begin);
    else
      line_str = "";

    //int linewidth = GetTextWidth(line_str, this._font);
    //if (this._lineX[line_iterator] + this._x + linewidth - 1 > 177)
      //Display(">>> '%s'", line_str);
    //Display("lineX = %d, linewidth = %d, ends at px = %d", this._lineX[line_iterator], linewidth, this._lineX[line_iterator] + this._x + linewidth - 1);
    ds.DrawString(this._lineX[line_iterator] + this._x, y, this._font, "%s", line_str);
    
    line_iterator++;
    y += line_height;
  }
  
  //
  // Draw explicit caret
  //
  if (this._caretStyle == eTypedCaret_Explicit && this.IsCaretShown)
  {
    int caret_x;
    int caret_y;
    Alignment align;
    int text_width;
    if (line_iterator > 0)
    {
      line_iterator--; // return to the last line
      text_width = GetTextWidth(line_str, this._font);
    }
    caret_x = this._lineX[line_iterator] + this._x + text_width;
    caret_y = this._y + line_iterator * line_height;
    align = eAlignLeft;
    this.DrawExplicitCaret(ds, caret_x, caret_y, align);
  }
}

//===========================================================================
//
// TypedTextDrawing::Draw
//
//===========================================================================
void TypedTextDrawing::Draw(DrawingSurface *ds)
{
  if (this._bkgColor != COLOR_TRANSPARENT)
    this.DrawRect(ds);
  this.DrawText(ds);
}
 +  // TypedTextDrawing is open source under the MIT License.
//
// TERMS OF USE - TypedTextDrawing MODULE
//
// Copyright (c) 2017-present Ivan Mogilko
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//////////////////////////////////////////////////////////////////////////////////////////
//
// Module performs rendering of TypedText state to the provided DrawingSurface.
//
//----------------------------------------------------------------------------------------
//
// TODO:
//  - Caret positioning when text is aligned at the right, and when the line of text
//    fills whole line.
//  - Typing text "outwards" when aligned at center or at the right.
//  - Right-to-left text style (semitic languages, etc).
//
//////////////////////////////////////////////////////////////////////////////////////////

#ifndef __TYPEDTEXTDRAWING_MODULE__
#define __TYPEDTEXTDRAWING_MODULE__

#ifndef __TYPEDTEXT_MODULE__
#error TypedTextDrawing requires TypedText module
#endif

#define TYPEDTEXTDRAWING_VERSION_00_00_70_00

// Maximal supported text lines
#define TYPEDTEXTDRAWING_MAXLINES 32

struct TypedTextDrawing extends TypewriterRender
{
  //
  // Configuration
  //
  
  /// Setup drawing position and bounds on the surface
  import void             SetDrawingRect(int x, int y, int width, int height);
  /// Setup text arrangement and display parameters
  import void             SetDrawingParams(FontType font, int color, int bkg_color = COLOR_TRANSPARENT,
                                           Alignment align = eAlignLeft, int line_spacing = 0);
  
  /// X position on surface
  import attribute int    X;
  /// Y position on surface
  import attribute int    Y;
  /// Width of a bounding rect
  import attribute int    Width;
  /// Height of a bounding rect
  import attribute int    Height;
  
  /// Text font
  import attribute FontType Font;
  /// Tells the height of a line of a text (not including spacing)
  readonly import attribute int LineHeight;
  /// Space between text lines
  import attribute int    LineSpacing;
  /// Horizontal alignment of text in line
  import attribute Alignment TextAlign;
  /// Fill colour of the background
  import attribute int    BkgColor;
  /// Text colour
  import attribute int    TextColor;
  
  /// Caret sprite number
  import attribute int    CaretSprite;
  
  //
  // Functionality
  //
  
  /// Render the current state to the given DrawingSurface
  import void             Draw(DrawingSurface *ds);
  
  //
  // Internal implementation
  //
  
  // Window postion
  protected int           _x;
  protected int           _y;
  protected int           _width;
  protected int           _height;
  
  // Text parameters
  protected int           _font;
  protected int           _lineSpacing;
  // Colour and alignment
  protected int           _bkgColor;
  protected int           _textColor;
  protected Alignment     _textAlign;
  
  // Caret sprite number
  protected int           _caretSprite;
  
  //
  // Calculated parameters to help with text arrangement
  //
  
  // The height of the font, in pixels
  protected int           _fontHeight;
  // Number of visible lines of text
  protected int           _maxVisLines;
  // Number of total lines stored in text box memory
  protected int           _lineCount;
  // The x coordinate where each new line begins
  protected int           _lineXDefault;
  // The x coordinates of every line
  protected int           _lineX[TYPEDTEXTDRAWING_MAXLINES];
  // Index of the first and last characters in the full string that correspond to particular line
  protected int           _lineBeginsAt[TYPEDTEXTDRAWING_MAXLINES];
  protected int           _lineEndsAt[TYPEDTEXTDRAWING_MAXLINES];
};

import void Clear(this TypedTextDrawing*);
/// Sets new string, resets all timers and commences typing
import void Start(this TypedTextDrawing*, String text);
/// Update typed text state, advancing it by single tick
import void Tick(this TypedTextDrawing*);

#endif  // __TYPEDTEXTDRAWING_MODULE__
 �0�E        ej��