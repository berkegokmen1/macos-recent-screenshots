import AppKit

// Render the real shelf with synthetic images, never the user's clipboard/files.
func generateReadmePreviews(at destination: URL) throws {
    _ = NSApplication.shared
    try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: true)
    let titles = ["Project notes", "Color palette", "Terminal", "Calendar", "UI sketch",
                  "Reading list", "Weekly plan", "App settings", "Dashboard", "Design ideas"]
    let accents: [NSColor] = [.systemBlue, .systemPurple, .systemGreen, .systemOrange, .systemPink]
    let date = ISO8601DateFormatter().date(from: "2026-10-08T22:30:00Z")!
    var shots: [Shot] = []
    for index in titles.indices {
        let title = titles[index]
        let image = NSImage(size: NSSize(width: 440, height: 280))
        image.lockFocus()
        NSColor(calibratedWhite: 0.96, alpha: 1).setFill()
        NSBezierPath(rect: NSRect(x: 0, y: 0, width: 440, height: 280)).fill()
        let accent = accents[index % accents.count]
        accent.withAlphaComponent(0.14).setFill()
        NSBezierPath(rect: NSRect(x: 0, y: 228, width: 440, height: 52)).fill()
        let attributes: [NSAttributedString.Key: Any] = [.font: NSFont.systemFont(ofSize: 19, weight: .semibold), .foregroundColor: NSColor.black]
        (title as NSString).draw(at: NSPoint(x: 24, y: 242), withAttributes: attributes)
        for row in 0..<4 {
            accent.withAlphaComponent(row == 0 ? 0.75 : 0.22).setFill()
            let y = CGFloat(174 - row * 42)
            let width = CGFloat(row == 0 ? 230 : 290 - (index + row) % 3 * 40)
            NSBezierPath(roundedRect: NSRect(x: 24, y: y, width: width, height: 12), xRadius: 6, yRadius: 6).fill()
        }
        image.unlockFocus()
        shots.append(Shot(url: destination.appendingPathComponent("sample-\(index).png"),
                    date: date.addingTimeInterval(Double(-index * 60)), image: image))
    }
    let delegate = AppDelegate()
    delegate.setupPanel()
    delegate.panel.appearance = NSAppearance(named: .aqua)
    for (filename, count) in [("shelf-grid.png", 10), ("shelf-compact.png", 3)] {
        delegate.shots = Array(shots.prefix(count))
        delegate.render()
        guard let view = delegate.panel.contentView,
              let bitmap = view.bitmapImageRepForCachingDisplay(in: view.bounds) else {
            throw NSError(domain: "Preview", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not render native shelf"])
        }
        view.layoutSubtreeIfNeeded()
        view.cacheDisplay(in: view.bounds, to: bitmap)
        guard let png = bitmap.representation(using: .png, properties: [:]) else {
            throw NSError(domain: "Preview", code: 2)
        }
        try png.write(to: destination.appendingPathComponent(filename))
        print("Rendered \(filename): \(bitmap.pixelsWide)×\(bitmap.pixelsHigh)")
    }
}
