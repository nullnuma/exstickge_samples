import java.nio.channels.DatagramChannel;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.awt.Dimension;
	
import javax.swing.JFrame;
import javax.swing.JPanel;

public class RecvPacket extends Thread{

	private DatagramChannel channel;
	private ByteBuffer buf;

	public final int[] R = new int[1600*900];
	public final int[] G = new int[1600*900];
	public final int[] B = new int[1600*900];

	private MyFrame frame;

	RecvPacket() throws Exception{
		channel = DatagramChannel.open();
		channel.socket().bind(new InetSocketAddress(0x4001));
		buf = ByteBuffer.allocate(1600);
		frame = new MyFrame(this);
	}

	public int ntoh(byte[] d, int offset){
		int v = 0;
		v |= (d[0] << 24) & 0xFF000000;
		v |= (d[1] << 16) & 0x00FF0000;
		v |= (d[2] <<  8) & 0x0000FF00;
		v |= (d[3] <<  0) & 0x000000FF;
		return v;
	}

	public void recv() throws Exception{
		buf.clear();
		channel.receive(buf);
		int len = buf.position();
		buf.flip();
		byte[] data = new byte[buf.limit()];
		buf.get(data);
		int line_counter = ntoh(data, 0);
		for(int i = 0; i < len-4; i++){
			R[line_counter*1600 + i] = (data[i+4] & 0x30) << 2;
			B[line_counter*1600 + i] = (data[i+4] & 0x0C) << 4;
			G[line_counter*1600 + i] = (data[i+4] & 0x03) << 6;
		}
		if(line_counter == 0){
			frame.frame.repaint();
		}
	}

	public void run(){
		frame.run();
		for(;;){
			try{
				recv();
			}catch(Exception e){
				e.printStackTrace();
			}
		}
	}
	
	public static void main(String ...args) throws Exception{
		RecvPacket obj = new RecvPacket();
		obj.start();
	}
}

class MyFrame {
    final int WIDTH = 1600, HEIGHT = 900;
	final RecvPacket recv;
	JFrame frame;

	MyFrame(RecvPacket recv){
		this.recv = recv;
	}

    public void run() {
        frame = new JFrame("RecvPacket");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(WIDTH, HEIGHT);
        frame.setLocationRelativeTo(null);

		PaintCanvas pane = new PaintCanvas(WIDTH, HEIGHT, this.recv);
        frame.getContentPane().add(pane);
		frame.pack();
		frame.setResizable(false);
        frame.setVisible(true);
    }

}

class PaintCanvas extends JPanel {

	private final int W, H;
	private final RecvPacket recv;
	
	public PaintCanvas(int W, int H, RecvPacket recv) {
		this.W = W;
		this.H = H;
		this.recv = recv;
		setBackground(Color.white);
		setPreferredSize(new Dimension(W, H));
	}
	
	@Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        BufferedImage canvas = new BufferedImage(W, H, BufferedImage.TYPE_INT_RGB);
        for (int x = 0; x < W; x++) {
            for (int y = 0; y < H; y++) {
				int pt = y * 1600 + x;
                canvas.setRGB(x, y, new Color(recv.R[pt], recv.G[pt], recv.B[pt]).getRGB());
            }
        }
        g.drawImage(canvas, 0, 0, null);
    }
	
}
