sidebar <- bs4DashSidebar(brandColor="white",
                          title="Patient Profiles",
                          src="favicon.png",
                          skin="light",
                          bs4SidebarMenu(
                            bs4SidebarMenuItem("About",
                                               tabName="about",
                                               icon="info"
                            ),
                            bs4SidebarMenuItem("Overview",
                                               tabName="header",
                                               icon="user"
                            ),
                            bs4SidebarMenuItem("Dosing",
                                               tabName="dosing",
                                               icon="syringe"
                            ),
                            bs4SidebarMenuItem("Adverse Events",
                                               tabName="adverse",
                                               icon="file-medical"
                            )
                          )
)