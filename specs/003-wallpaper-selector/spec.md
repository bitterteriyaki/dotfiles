# Feature Specification: Wallpaper Selector

**Feature Branch**: `003-wallpaper-selector`

**Created**: 2026-10-15

**Status**: Draft

**Input**: User description: "Create a component that lets me select a wallpaper from the `~/.local/share/wallpapers/` folder. If needed, look at the https://github.com/end-4/dots-hyprland repository to see how it was done there."

## Clarifications

### Session 2026-10-15

- Q: How is the selector opened? → A: Only through the shell's external command interface
  (toggle/open/close). No global shortcut in this feature; key bindings belong to the keybinds
  task.
- Q: Where does it appear? → A: A floating panel centred horizontally just below the bar, on the
  bar's monitor, above the windows — as in end-4's dotfiles.
- Q: How are the previews laid out? → A: A single horizontal row of thumbnails that scrolls
  sideways.
- Q: How does the chosen wallpaper cover the two monitors? → A: One image stretched across both
  monitors, as the background does today.
- Q: Is the choice remembered? → A: Yes, across shell restarts and reboots, falling back to
  `default.png` when nothing was saved or the saved file no longer exists.
- Q: Does picking a wallpaper regenerate the colour palette? → A: No; colours from the wallpaper
  are a separate feature.
- Q: What happens after clicking a wallpaper? → A: It is applied and the selector closes.
- Q: How does the selector close without picking? → A: Escape, a click outside the panel on either
  monitor, or the external command.
- Q: Keyboard navigation? → A: Left/Right move the highlight along the row, Enter applies.
- Q: Search by name? → A: No.
- Q: Random wallpaper? → A: Only through the external command (`random`), with no button.
- Q: Subfolders? → A: Images in subfolders are listed too, all in the same row.
- Q: Order? → A: Alphabetical by path.
- Q: How is the current wallpaper shown? → A: Highlighted, and the row scrolls to it on open;
  keyboard selection starts there.
- Q: Is the switch animated? → A: No, the background changes instantly.
- Q: File names on thumbnails? → A: No, images only.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Pick a wallpaper (Priority: P1)

The user opens the selector with the external command. A panel appears just below the bar with a
horizontal row of thumbnails of every image in `~/.local/share/wallpapers/` and its subfolders,
the current wallpaper highlighted. Clicking a thumbnail (or moving with Left/Right and pressing
Enter) changes the background on both monitors at once and closes the panel.

**Why this priority**: it is the whole point of the feature.

**Independent Test**: put three images in the folder (one in a subfolder), open the selector,
pick a different one, and see the background change instantly on both monitors and the panel
close.

**Acceptance Scenarios**:

1. **Given** the folder has images, **When** the user opens the selector, **Then** a panel appears
   centred just below the bar on the bar's monitor, showing one thumbnail per image, including
   images in subfolders, ordered alphabetically by path, with no file names.
2. **Given** the selector opens, **When** it appears, **Then** the current wallpaper's thumbnail is
   highlighted and scrolled into view, and keyboard selection starts on it.
3. **Given** the selector is open, **When** the user clicks a thumbnail, **Then** the background
   changes instantly to that image, stretched across both monitors, and the selector closes.
4. **Given** the selector is open, **When** the user presses Left/Right, **Then** the highlight
   moves to the previous/next thumbnail, scrolling the row if needed; **When** they press Enter,
   **Then** the highlighted image is applied and the selector closes.
5. **Given** there are more thumbnails than fit in the panel, **When** the user scrolls (mouse
   wheel or touchpad) over the row, **Then** it scrolls sideways.

---

### User Story 2 - The choice survives restarts (Priority: P1)

The wallpaper the user picked is still the background after the shell restarts or the machine
reboots.

**Why this priority**: without it, every restart would undo the choice.

**Independent Test**: pick a wallpaper, restart the shell, and see the same background.

**Acceptance Scenarios**:

1. **Given** the user picked a wallpaper, **When** the shell restarts, **Then** the background is
   that wallpaper.
2. **Given** nothing was ever picked, **When** the shell starts, **Then** the background is
   `default.png`.
3. **Given** the saved wallpaper file was deleted or moved, **When** the shell starts, **Then** the
   background falls back to `default.png`.

---

### User Story 3 - Close without picking (Priority: P2)

The user can dismiss the selector without changing anything.

**Why this priority**: it is needed for normal use, but the core value is in Stories 1 and 2.

**Independent Test**: open the selector and close it in each way; the background stays the same.

**Acceptance Scenarios**:

1. **Given** the selector is open, **When** the user presses Escape, clicks outside the panel on
   either monitor, or runs the external close/toggle command, **Then** the selector closes and the
   background is unchanged.

---

### User Story 4 - Random wallpaper by command (Priority: P3)

A `random` external command applies a random image from the folder without opening the panel.

**Why this priority**: a convenience for scripts or a future key binding.

**Independent Test**: run the random command a few times and see the background change.

**Acceptance Scenarios**:

1. **Given** the folder has two or more images, **When** the random command runs, **Then** a
   different image from the current one is applied and remembered as in Story 2.
2. **Given** the folder has one image or none, **When** the random command runs, **Then** nothing
   changes and no error is shown.

---

### Edge Cases

- The folder is empty or missing: the selector opens with a short "No wallpapers found in
  ~/.local/share/wallpapers" message instead of an empty row.
- Files that are not images (or hidden files) in the folder or its subfolders are not listed.
- Very large images (the current one is 7680×2160, 32 MB): the row of thumbnails appears without a
  visible delay and scrolling stays smooth.
- An image is added to or removed from the folder: the next time the selector opens, the list
  reflects it.
- Two images with the same name in different subfolders: both are listed, ordered by full path.
- `default.png` itself is missing and nothing valid is saved: the background shows a plain colour
  from the shell's palette instead of failing.
- The selector is opened while the sidebar is open (or vice versa): only one of them is open at a
  time; opening one closes the other.
- Quickshell restarts while the selector is open: it comes back closed.
- The other monitor (`DVI-D-1`) never shows the panel.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The selector MUST list every image file in `~/.local/share/wallpapers/` and its
  subfolders (recursively), excluding non-image and hidden files, ordered alphabetically by path.
- **FR-002**: The selector MUST appear as a floating panel centred horizontally just below the bar
  on the bar's monitor, above the windows, showing the images as a single horizontal row of
  thumbnails without file names, scrollable sideways.
- **FR-003**: On opening, the current wallpaper MUST be highlighted and scrolled into view, and
  keyboard selection MUST start on it.
- **FR-004**: Clicking a thumbnail, or pressing Enter on the highlighted one, MUST change the
  background instantly to that image, stretched across both monitors as today, and close the
  selector.
- **FR-005**: Left/Right MUST move the highlight to the previous/next thumbnail, scrolling as
  needed.
- **FR-006**: The selector MUST close without changes on Escape, on a click outside the panel on
  either monitor, and on the external close/toggle command.
- **FR-007**: The shell MUST expose external commands to open, close and toggle the selector, and
  to apply a random wallpaper (different from the current one when at least two images exist)
  without opening it. No global shortcut is added by this feature.
- **FR-008**: The chosen wallpaper MUST persist across shell restarts and reboots; when nothing
  valid is saved, the background MUST fall back to `default.png`, and to a plain palette colour if
  that is missing too.
- **FR-009**: An empty or missing folder MUST show a "No wallpapers found" message in the panel.
- **FR-010**: Thumbnails MUST appear without a visible delay even for very large images.
- **FR-011**: The selector and the sidebar MUST NOT be open at the same time.
- **FR-012**: The selector MUST follow the shell's existing look (palette, rounded corners, hover
  and press feedback of clickable elements) and MUST NOT appear on the other monitor.

### Key Entities

- **Wallpaper**: an image file under `~/.local/share/wallpapers/`; identified by its path.
- **Current wallpaper**: the path of the applied wallpaper, saved so it survives restarts.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: From a closed selector, the user changes the wallpaper in at most two actions (open,
  click) or open + arrows + Enter.
- **SC-002**: The row of thumbnails is fully visible within 1 second of opening, with the current
  folder's images (including the 7680×2160 one).
- **SC-003**: After picking, both monitors show the new wallpaper in the same instant, with no
  visible gap or mismatch at the seam.
- **SC-004**: In 10 out of 10 shell restarts, the background is the last picked wallpaper.
- **SC-005**: Ten consecutive `random` commands with two or more images never re-apply the
  wallpaper already shown.

## Assumptions

- The background keeps being drawn by the shell itself, as it is today; no external wallpaper
  daemon is introduced.
- Images are the common still formats (PNG, JPEG, WebP); animated or video wallpapers are out of
  scope.
- Generating colours from the wallpaper (matugen) is a separate feature.
- The Hyprland key binding that would call the external command belongs to the keybinds task.
- The saved choice lives outside the chezmoi-managed files, so `chezmoi apply` never resets it.
