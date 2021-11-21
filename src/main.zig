const std = @import("std");
const zgt = @import("zgt");
const bottom = @import("bottom");

pub usingnamespace zgt.cross_platform;

pub fn encode(button: *zgt.Button_Impl) !void {
    // If we received the event, this means we're parented, so it's safe to assert
    const root = button.getRoot().?;

    // Get 'encode-text' and cast it to a TextField
    const input = root.get("encode-text").?.as(zgt.TextField_Impl);

    // Same cast, but with 'decode-text'
    const output = root.get("decode-text").?.as(zgt.TextField_Impl);

    const allocator = zgt.internal.scratch_allocator;
    const encoded = try bottom.encoder.encodeAlloc(input.getText(), allocator);

    // Free old text
    allocator.free(output.getText());

    output.setText(encoded);
}

pub fn decode(button: *zgt.Button_Impl) !void {
    const root = button.getRoot().?;
    const input = root.get("decode-text").?.as(zgt.TextField_Impl);
    const output = root.get("encode-text").?.as(zgt.TextField_Impl);

    const allocator = zgt.internal.scratch_allocator;
    const decoded = try bottom.decoder.decodeAlloc(input.getText(), allocator);
    allocator.free(output.getText());

    output.setText(decoded);
}

pub fn main() !void {
    try zgt.backend.init();

    var window = try zgt.Window.init();
    try window.set(
        zgt.Column(.{}, .{
            zgt.Label(.{ .text = "Bottom encoder and decoder" }),
            zgt.Column(.{}, .{
                zgt.Row(.{}, .{
                    zgt.Label(.{ .text = "Input text" }),
                    zgt.TextField(.{ })
                        .setName("encode-text"),
                }),
                zgt.Row(.{}, .{
                    zgt.Label(.{ .text = "Output text" }),
                    zgt.TextField(.{ })
                        .setName("decode-text"),
                }),
            }),
            zgt.Row(.{}, .{
                zgt.Button(.{ .label = "Encode", .onclick = encode }),
                zgt.Button(.{ .label = "Decode", .onclick = decode }),
            })
        })
    );

    window.resize(800, 600);
    window.show();

    zgt.runEventLoop();
}
