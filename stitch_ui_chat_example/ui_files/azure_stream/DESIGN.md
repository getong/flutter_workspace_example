# Design System Specification: The Fluid Precision Framework

## 1. Overview & Creative North Star
### Creative North Star: "The Digital Atrium"
This design system moves away from the rigid, boxy constraints of traditional Material Design to embrace "The Digital Atrium"—a philosophy centered on light, breathability, and architectural depth. We are not building a flat interface; we are crafting a spatial experience where content sits on layered planes of light.

To break the "template" look, we utilize **intentional asymmetry** and **tonal layering**. By favoring large-scale typography and expansive white space over structural lines, we create an editorial feel that suggests premium quality and effortless utility. The interface should feel like it was carved from a single block of frosted glass and light.

---

## 2. Colors & Surface Logic
The palette is anchored by a vibrant, energetic blue, but its "premium" feel is derived from how it interacts with the sophisticated neutral scales.

### The "No-Line" Rule
**Strict Mandate:** 1px solid borders are prohibited for sectioning or containment. 
Boundaries must be defined exclusively through:
1.  **Background Color Shifts:** Placing a `surface-container-low` element against a `surface` background.
2.  **Negative Space:** Using the spacing scale to create distinct visual groupings.
3.  **Tonal Transitions:** Subtle shifts in hue to denote interactive zones.

### Surface Hierarchy & Nesting
Treat the UI as a physical stack of materials. Use the `surface-container` tiers to create "nested depth":
*   **Base Layer:** `surface` (#f5f6ff) – The primary canvas.
*   **Mid-Level:** `surface-container-low` (#ecf0ff) – For secondary content areas.
*   **Floating Elements:** `surface-container-lowest` (#ffffff) – For cards and interactive modules to provide maximum "pop."

### The Glass & Gradient Rule
To move beyond "out-of-the-box" Flutter, use **Glassmorphism** for floating elements (e.g., App Bars, Bottom Sheets). Apply `surface` colors at 70% opacity with a 20px-30px backdrop blur.
*   **Signature Texture:** Main CTAs should not be flat. Use a linear gradient: `primary` (#005e9f) to `primary_container` (#44a5ff) at a 135° angle to add "soul" and dimension.

---

## 3. Typography: Editorial Authority
We use **Inter** for its mathematical precision and neutral warmth. The hierarchy is designed to feel like a high-end magazine.

*   **Display (lg/md/sm):** Use for "Hero" moments. Reduce letter-spacing by -2% to create a tight, custom-type feel.
*   **Headline (lg/md/sm):** The primary organizational tool. Always use `on-surface` (#1a2f50).
*   **Title (lg/md/sm):** Used for card headers and navigation. These should feel authoritative.
*   **Body (lg/md):** The workhorse. Maintain a line-height of 1.5x for maximum readability and "breathable" feel.
*   **Label (md/sm):** Use `on-surface-variant` (#485c80) in All-Caps with +5% letter spacing for a refined, utilitarian look.

---

## 4. Elevation & Depth: Tonal Layering
Traditional drop shadows are often "dirty." In this design system, we use light to communicate height.

*   **The Layering Principle:** Instead of a shadow, place a `surface-container-lowest` (#ffffff) card on top of a `surface-container-low` (#ecf0ff) background. The delta in brightness creates a "Soft Lift."
*   **Ambient Shadows:** If a floating effect is required (e.g., a FAB), use a shadow color tinted with the primary hue: `Shadow: 0px 12px 32px rgba(0, 94, 159, 0.08)`.
*   **The "Ghost Border" Fallback:** If a container lacks contrast, use a "Ghost Border": `outline-variant` (#9aadd6) at 15% opacity. Never use 100% opacity for lines.

---

## 5. Components

### Buttons: The Kinetic Core
*   **Primary:** Rounded `xl` (1.5rem/24px). Gradient fill (Primary to Primary-Container). No border. Label in `on-primary`.
*   **Secondary:** `surface-container-highest` fill. No border. Text in `primary`.
*   **Tertiary:** Transparent background. Text in `primary`. For low-emphasis actions.

### Input Fields: The Recessed Look
*   **Styling:** Fill with `surface-container-low`. Radius: `lg` (1rem/16px).
*   **States:** On focus, transition the background to `surface-container-lowest` and add a 2px "Ghost Border" of `primary` at 40% opacity. 
*   **Labels:** Floating labels using `label-md` style.

### Message Bubbles: The Conversation Flow
*   **Sender (User):** `primary` fill. Text in `on-primary`. Shape: `xl` radius, but the bottom-right corner is `sm` (4px) to "point" to the origin.
*   **Receiver:** `surface-container-high` fill. Text in `on-surface`. Shape: `xl` radius, but the bottom-left corner is `sm` (4px).
*   **Spacing:** Group bubbles from the same sender with 4px vertical gaps; 16px gaps between different senders.

### Cards & Lists: Editorial Grouping
*   **Constraint:** Dividers are forbidden. 
*   **Execution:** Use a 24px vertical margin between list items. For complex data, use a `surface-container-low` card wrapper with `xl` (1.5rem) rounded corners.

---

## 6. Do's and Don'ts

### Do:
*   **DO** use "Over-sized" margins. If you think there's enough white space, add 8px more.
*   **DO** use `surface-tint` sparingly to highlight active states in navigation.
*   **DO** ensure all touch targets are at least 48x48dp, regardless of the visual size of the icon.

### Don't:
*   **DON'T** use pure black (#000000) for text. Use `on-surface` (#1a2f50) to maintain tonal depth.
*   **DON'T** use "Default" 8px rounded corners. Stick to the `xl` (24px) or `lg` (16px) tokens to maintain the "Soft Minimalist" aesthetic.
*   **DON'T** stack more than three levels of surface nesting. It breaks the "Atrium" clarity.

---

## 7. Signature Interaction: "The Fluid Lift"
When a user interacts with a card or button, it should not just change color. It should scale slightly (1.02x) and transition from its current surface tier to one tier higher (e.g., `surface-container-low` to `surface-container-highest`). This creates a tactile, responsive environment that feels alive.