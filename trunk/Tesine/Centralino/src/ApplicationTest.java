

import gui.frMain;
import java.awt.Dimension;
import java.awt.Toolkit;
import javax.swing.UIManager;
import javax.swing.plaf.metal.MetalLookAndFeel;

public class ApplicationTest {

  boolean packFrame = false;

  // Construct the application

  public ApplicationTest() {
    final frMain frame = new frMain();
    // Validate frames that have preset sizes
    // Pack frames that have useful preferred size info, e.g. from their layout
    if (packFrame) {
      frame.pack();
    }
    else {
      frame.validate();
    }
    // Center the window
    final Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
    final Dimension frameSize = frame.getSize();
    if (frameSize.height > screenSize.height) {
      frameSize.height = screenSize.height;
    }
    if (frameSize.width > screenSize.width) {
      frameSize.width = screenSize.width;
    }
    frame.setLocation((screenSize.width - frameSize.width) / 2, (screenSize.height - frameSize.height) / 2);
    frame.setVisible(true);
  }

  // Main method

  public static void main(final String[] args) {
    try {
      UIManager.setLookAndFeel(new MetalLookAndFeel());
    }
    catch (final Exception e) {
      e.printStackTrace();
    }
    new ApplicationTest();
  }
}
