/**
 * Copyright (C) 1998-2010 eIrOcA (eNrIcO Croce & sImOnA Burzio)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/
 * 
 */
package gui;

import java.awt.AWTEvent;
import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.GridLayout;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.WindowEvent;
import javax.swing.JCheckBox;
import javax.swing.JFrame;
import javax.swing.JPanel;
import centralino.CentralinoISDN;

public class frMain extends JFrame {

  /**
   *
   */
  private static final long serialVersionUID = 1L;
  JPanel jPanel1 = new JPanel();
  BorderLayout borderLayout1 = new BorderLayout();
  GridLayout gridLayout1 = new GridLayout();
  JCheckBox cbChan01 = new JCheckBox();
  JCheckBox cbChan02 = new JCheckBox();
  JCheckBox cbChan03 = new JCheckBox();
  JCheckBox cbChan04 = new JCheckBox();
  JCheckBox cbChan05 = new JCheckBox();
  JCheckBox cbChan06 = new JCheckBox();
  JCheckBox cbChan07 = new JCheckBox();
  JCheckBox cbChan08 = new JCheckBox();
  JCheckBox cbChan09 = new JCheckBox();
  JCheckBox cbChan10 = new JCheckBox();
  JCheckBox cbChan11 = new JCheckBox();
  JCheckBox cbChan12 = new JCheckBox();
  JCheckBox cbChan13 = new JCheckBox();
  JCheckBox cbChan14 = new JCheckBox();
  JCheckBox cbChan15 = new JCheckBox();
  JCheckBox cbChan16 = new JCheckBox();
  JCheckBox cbChan17 = new JCheckBox();
  JCheckBox cbChan18 = new JCheckBox();
  JCheckBox cbChan19 = new JCheckBox();
  JCheckBox cbChan20 = new JCheckBox();
  JCheckBox cbChan21 = new JCheckBox();
  JCheckBox cbChan22 = new JCheckBox();
  JCheckBox cbChan23 = new JCheckBox();
  JCheckBox cbChan24 = new JCheckBox();
  JCheckBox cbChan25 = new JCheckBox();
  JCheckBox cbChan26 = new JCheckBox();
  JCheckBox cbChan27 = new JCheckBox();
  JCheckBox cbChan28 = new JCheckBox();
  JCheckBox cbChan29 = new JCheckBox();
  JCheckBox cbChan30 = new JCheckBox();
  JPanel jPanel2 = new JPanel();
  GridLayout gridLayout2 = new GridLayout();

  CentralinoISDN centralino;

  // Construct the frame

  public frMain() {
    enableEvents(AWTEvent.WINDOW_EVENT_MASK);
    try {
      jbInit();
    }
    catch (final Exception e) {
      e.printStackTrace();
    }
  }

  // Component initialization

  void btAbout_actionPerformed(final ActionEvent e) {
    final frMain_AboutBox frame = new frMain_AboutBox(null);
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
    frame.setModal(true);
    frame.setVisible(true);
  }

  // Overriden so we can exit on System Close

  void cbChan01_actionPerformed(final ActionEvent e) {
    if (cbChan01.isSelected()) {
      centralino.incomingCall(1);
    }
    else {
      centralino.closingCall(1);
    }
  }

  private void jbInit() throws Exception {
    this.setSize(new Dimension(400, 250));
    gridLayout1.setRows(10);
    gridLayout1.setColumns(3);
    cbChan01.setText("01");
    cbChan01.addActionListener(new java.awt.event.ActionListener() {

      @Override
      public void actionPerformed(final ActionEvent e) {
        cbChan01_actionPerformed(e);
      }
    });
    cbChan02.setText("02");
    cbChan03.setText("03");
    cbChan04.setText("04");
    cbChan05.setText("05");
    cbChan06.setText("06");
    cbChan07.setText("07");
    cbChan08.setText("08");
    cbChan09.setText("09");
    cbChan10.setText("10");
    cbChan11.setText("11");
    cbChan12.setText("12");
    cbChan13.setText("13");
    cbChan14.setText("14");
    cbChan15.setText("15");
    cbChan16.setText("16");
    cbChan17.setText("17");
    cbChan18.setText("18");
    cbChan19.setText("19");
    cbChan20.setText("20");
    cbChan21.setText("21");
    cbChan22.setText("22");
    cbChan23.setText("23");
    cbChan24.setText("24");
    cbChan25.setText("25");
    cbChan26.setText("26");
    cbChan27.setText("27");
    cbChan28.setText("28");
    cbChan29.setText("29");
    cbChan30.setText("30");
    jPanel2.setLayout(gridLayout2);
    gridLayout2.setRows(10);
    gridLayout2.setColumns(2);

    jPanel1.setLayout(gridLayout1);
    setTitle("Test Applicazione");
    getContentPane().setLayout(borderLayout1);
    getContentPane().add(jPanel1, BorderLayout.WEST);
    jPanel1.add(cbChan01, null);
    jPanel1.add(cbChan11, null);
    jPanel1.add(cbChan21, null);
    jPanel1.add(cbChan02, null);
    jPanel1.add(cbChan12, null);
    jPanel1.add(cbChan22, null);
    jPanel1.add(cbChan03, null);
    jPanel1.add(cbChan13, null);
    jPanel1.add(cbChan23, null);
    jPanel1.add(cbChan04, null);
    jPanel1.add(cbChan14, null);
    jPanel1.add(cbChan24, null);
    jPanel1.add(cbChan05, null);
    jPanel1.add(cbChan15, null);
    jPanel1.add(cbChan25, null);
    jPanel1.add(cbChan06, null);
    jPanel1.add(cbChan16, null);
    jPanel1.add(cbChan26, null);
    jPanel1.add(cbChan07, null);
    jPanel1.add(cbChan17, null);
    jPanel1.add(cbChan27, null);
    jPanel1.add(cbChan08, null);
    jPanel1.add(cbChan18, null);
    jPanel1.add(cbChan28, null);
    jPanel1.add(cbChan09, null);
    jPanel1.add(cbChan19, null);
    jPanel1.add(cbChan29, null);
    jPanel1.add(cbChan10, null);
    jPanel1.add(cbChan20, null);
    jPanel1.add(cbChan30, null);
    getContentPane().add(jPanel2, BorderLayout.CENTER);

    centralino = new CentralinoISDN(30, 20, "275");
  }

  @Override
  protected void processWindowEvent(final WindowEvent e) {
    super.processWindowEvent(e);
    if (e.getID() == WindowEvent.WINDOW_CLOSING) {
      System.exit(0);
    }
  }
}
